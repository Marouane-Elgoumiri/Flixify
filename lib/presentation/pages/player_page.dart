import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:my_app/domain/entities/movie.dart';
import 'package:my_app/presentation/controllers/player_controller.dart';

/// Full-screen player page using `webview_flutter` + Vidking.
///
/// Pipeline:
///   1. Take `Movie` from `Get.arguments`.
///   2. Build the Vidking iframe URL (movie OR TV series).
///   3. The hosted page posts `PLAYER_EVENT` messages.
///   4. We capture them via `webController.addJavaScriptChannel`.
///   5. [PlayerController] parses each event and saves progress to Firestore.
///
/// Section 6 design choices:
///   • Hybrid save: every 30 seconds while playing + on pause / ended.
///   • JS bridge channel name: `PLYR_BRIDGE` (matches the Vidking event API).
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final PlayerController controller;
  late final WebViewController webController;

  @override
  void initState() {
    super.initState();

    controller = Get.find<PlayerController>();

    final movie = Get.arguments as Movie;
    controller.attachMovie(movie);

    // Lock orientation to landscape for cinema experience.
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide the system status bar (fullscreen feel).
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'PLYR_BRIDGE',
        onMessageReceived: (msg) => controller.onPlayerMessage(msg.message),
      )
      ..loadRequest(Uri.parse(controller.embedUrl.value));
  }

  @override
  void dispose() {
    // Restore portrait mode when leaving.
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Reset player state but KEEP the controller instance alive
    // (it's registered permanent in InitialBinding).
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
