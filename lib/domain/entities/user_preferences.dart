/// Per-user preferences (theme, default filter, etc.).
class UserPreferences {
  const UserPreferences({
    this.darkMode = true,
    this.showAdultContent = false,
    this.defaultCategory = 'popular',
  });

  final bool darkMode;
  final bool showAdultContent;

  /// 'popular' | 'trending' | 'top_rated' | 'now_playing'
  final String defaultCategory;

  UserPreferences copyWith({
    bool? darkMode,
    bool? showAdultContent,
    String? defaultCategory,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      showAdultContent: showAdultContent ?? this.showAdultContent,
      defaultCategory: defaultCategory ?? this.defaultCategory,
    );
  }
}
