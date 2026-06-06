# Flutter Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Isar DB Keep Rules
-keep class io.isar.** { *; }
-keep class * extends io.isar.isar_flutter_libs.** { *; }

# WorkManager Rules
-keep class androidx.work.** { *; }
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }
-keepnames class androidx.work.impl.background.firebase.FirebaseJobScheduler { *; }

# Play Store / Deferred Components warnings
-dontwarn com.google.android.play.core.**

