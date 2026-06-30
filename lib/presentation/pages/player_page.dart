import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:my_app/core/constants/api_constants.dart';
import 'package:my_app/core/utils/tmdb_color.dart';
import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/controllers/player_controller.dart';

/// Full-screen player page using `webview_flutter` + Vidsync.
///
/// Pipeline:
///   1. Take `Movie` from `Get.arguments`.
///   2. Build Vidsync URL atomically (sync, with autoPlay=true).
///   3. WebView loads URL on first build (no async bridging on
///      initState → no widget rebuild loop).
///   4. Firestore resume is OPTIONAL: if it returns a saved position,
///      we wait for the player's `play` event then run JS to seek
///      the video element to that offset.
///   5. [PlayerController] saves progress every 30s + on pause/ended.
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final PlayerController controller;
  late final WebViewController webController;
  late final String _initialUrl;

  /// Saved seek-target from Firestore. Applied as soon as we know the
  /// DOM has video (which is after the first play event).
  int? _pendingStartSeconds;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PlayerController>();

    final movie = Get.arguments as Movie;

    // Build the URL atomically — synchronous, no setState inside initState.
    _initialUrl = VidsyncUrls.movie(
      movie.id,
      theme: hexColorForMovieId(movie.id),
    );

    controller.attachMovie(movie);

    // Landscape orientation for cinema experience.
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'PLYR_BRIDGE',
        onMessageReceived: (msg) {
          // We won't know which event the JS sends for "loaded" vs "play",
          // so we just forward everything to the controller.
          controller.onPlayerMessage(msg.message);
          // Once the player is ready, attempt resume if needed.
          if (_pendingStartSeconds != null && _pendingStartSeconds! > 0) {
            _applyResume();
          }
        },
      )
      ..loadRequest(Uri.parse(_initialUrl));

    // Kick off async resume lookup.
    _fetchStartTimeAsync(movie);
  }

  Future<void> _fetchStartTimeAsync(Movie movie) async {
    try {
      final saved = await controller.userDataRepo.getLatestProgressFor(movie.id);
    final cs = saved?.currentSeconds;
    final seconds = (cs ?? 0).toInt();
      if (seconds > 1) {
        _pendingStartSeconds = seconds;
      }
    } catch (_) {
      // ignore — start at 0 on any failure
    }
  }

  /// Inject a tiny JS that seeks the first <video> element to `_pendingStartSeconds`.
  /// Vidsync's player itself listens to player events. We don't rely on
  /// a particular JS API — instead we use the standard WebView method
  /// to call the embedded `<video>`. This works because Vidsync's iframe
  /// is loaded IN our WebView (not out-of-process).
  Future<void> _applyResume() async {
    final seconds = _pendingStartSeconds;
    if (seconds == null) return;
    _pendingStartSeconds = null; // only attempt once
    try {
      await webController.runJavaScript(
        '(() => {'
        '  const v = document.querySelector("video");'
        '  if (v) {'
        '    try { v.currentTime = $seconds; } catch(e) {}'
        '  }'
        '})();',
      );
    } catch (_) {
      // The player may not have finished loading yet; ignore silently.
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    controller.detachMovie();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            WebViewWidget(controller: webController),
            Positioned(
              top: 8,
              left: 8,
              child: Obx(() {
                if (!controller.showBackButton.value) {
                  return const SizedBox.shrink();
                }
                return Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                );
              }),
            ),
            // Loader is shown only BEFORE first JS event arrives.
            // We deliberately do NOT include `embedUrl` here, so the
            // Obx does not cause reload loops if another widget mutates
            // the controller's Rx state.
            Obx(() {
              if (controller.isReady.value) {
                return const SizedBox.shrink();
              }
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }),
          ],
        ),
      ),
    );
  }
}
