# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Play Core Library classes
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# If you're using Play Store split APKs:
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep any other Play-related classes you are using
-keep class com.android.installreferrer.** { *; } #If you use install referrer

# Keep other necessary classes (adjust as needed)
-keep class * { *; }  # Be careful with this, only if needed!
-dontwarn com.google.android.play.core.**
-dontwarn com.android.installreferrer.**