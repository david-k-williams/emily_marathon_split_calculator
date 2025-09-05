class ReleaseNote {
  final String version;
  final String date;
  final List<String> features;
  final List<String> improvements;
  final List<String> fixes;

  const ReleaseNote({
    required this.version,
    required this.date,
    required this.features,
    required this.improvements,
    required this.fixes,
  });
}

class ReleaseNotesData {
  static const String currentVersion = "1.0.9";

  static const List<ReleaseNote> releaseNotes = [
    ReleaseNote(
      version: "1.0.9",
      date: "September 2025",
      features: [
        "⚡ Pace Calculator - Convert time and distance to pace per mile/km",
        "🔮 Race Predictions - Predict times across different distances using multiple formulas",
        "📱 Responsive Design - Optimized for mobile and desktop",
        "🌙 Dark Mode Support - Beautiful dark and light themes",
        "📊 Extended Race Distances - Support for ultra marathons up to 50 miles",
        "📤 Export Functionality - Share your calculated splits",
        "🎨 Modern UI - Blue and pink color scheme with Material Design 3",
        "📋 Release Notes - Version information and update history",
      ],
      improvements: [
        "Consistent input controls across all pages",
        "Responsive tab selector that adapts to screen size",
        "Unified units toggle (miles/km) across all calculators",
        "Mobile-optimized time input controls",
        "Improved visual hierarchy and spacing",
        "Better error handling and user feedback",
        "Enhanced mobile layout and touch interactions",
      ],
      fixes: [
        "Fixed constraint issues on mobile devices",
        "Resolved units toggle inconsistency between pages",
        "Fixed default units selection (now defaults to imperial)",
        "Improved layout stability across different screen sizes",
        "Fixed calculation triggers to only occur on button press",
        "Resolved rendering issues on various screen sizes",
      ],
    ),
    ReleaseNote(
      version: "1.0.1",
      date: "November 2024",
      features: [
        "🏃‍♀️ Ultra Marathon Support - Added distances up to 50 miles",
        "📊 Extended Distance Range - Support for 1 mile to 50 mile races",
      ],
      improvements: [
        "Enhanced race distance selection",
        "Improved split calculations for longer distances",
      ],
      fixes: [
        "Fixed calculation accuracy for ultra distances",
        "Improved performance for longer race calculations",
      ],
    ),
    ReleaseNote(
      version: "1.0.0",
      date: "October 2024",
      features: [
        "🏃‍♀️ Split Calculator - Calculate race splits and pacing strategy",
        "📊 Standard Race Distances - Support for 1 mile to marathon distances",
        "🌙 Dark Mode Support - Beautiful dark and light themes",
        "📤 Export Functionality - Share your calculated splits",
      ],
      improvements: [
        "Initial release with core functionality",
        "Clean and intuitive user interface",
      ],
      fixes: [
        "Initial stable release",
      ],
    ),
  ];
}
