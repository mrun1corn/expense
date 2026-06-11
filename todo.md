# Smart Expense Tracker — Project Todo List

This is the actionable checklist for building the **Smart Expense Tracker** (Flutter + Isar + Firebase + Gemini AI + Awesome Notifications).

---

## 🛠️ Phase 0: Environment Setup
- [x] Upgrade to **Flutter 3.22+** stable: `flutter upgrade`
- [x] Install **Android Studio** (Hedgehog+) with Android SDK 34
- [x] Install **FlutterFire CLI**: `dart pub global activate flutterfire_cli`
- [x] Install **Firebase CLI**: `npm install -g firebase-tools` then `firebase login` (Note: Pre-installed & verified)
- [x] Set up **Google Cloud / Firebase Project** at `console.firebase.google.com`
  - [x] Enable **Generative Language API** (Google Cloud Console)
  - [x] Enable **Cloud Firestore API**
  - [x] Enable **Firebase Authentication API**
  - [x] Register Android app (package: `com.mrun1corn.smexp`)
  - [x] Enable **Google Sign-In** under Auth Providers
  - [x] Create **Firestore Database** (start in test mode)
- [x] Set up Git & GitHub repo
- [x] Create `.gitignore` (include `google-services.json`, `.env`, `*.keystore`)

---

## 🚀 Phase 1: Flutter Project Bootstrap
- [x] Create project: `flutter create smart_expense_tracker --org com.yourname --platforms android`
- [x] Update `pubspec.yaml` with all dependencies (Riverpod, GoRouter, Isar, Firebase, Awesome Notifications, WorkManager, fl_chart, google_generative_ai, freezed, etc.)
  - [x] *Note: Add dependency overrides for `analyzer` if Isar 3.x conflicts with modern Dart code-gen tools.*
- [x] Run `flutter pub get`
- [x] Add `analysis_options.yaml` with strict `very_good_analysis` rules
- [x] Configure `android/app/build.gradle` (`minSdkVersion 23`, `targetSdkVersion 34`, `compileSdkVersion 34`, `multiDexEnabled true`)
- [x] Add Android permissions to `AndroidManifest.xml` (exact alarms, vibrate, boot completed, post notifications, foreground service)
- [x] Configure `workmanager` BackgroundWorker service in `AndroidManifest.xml`
- [x] Set up GoRouter at `lib/core/router/app_router.dart` (defining all paths & auth guards)
- [x] Build Material 3 theme (dynamic color support, light/dark themes)
- [x] Wrap `MaterialApp` in Riverpod `ProviderScope`
- [x] Initialize `IsarService` singleton opened at app start
- [x] Configure launcher icons & splash screen

---

## 🔥 Phase 2: Firebase Setup
- [x] Run `flutterfire configure` to generate `firebase_options.dart` and download `google-services.json`
- [x] Initialize Firebase in `main.dart`
- [x] Configure Firebase Crashlytics & Firebase Analytics
- [x] Deploy Firestore security rules (restrict reads/writes to authenticated owners)
- [x] Create Firestore composite indexes:
  - [x] `expenses` collection: `date DESC` + `category ASC`
  - [x] `expenses` collection: `date DESC` (monthly filtering)
  - [x] `patterns` collection: `confidence DESC` + `isDismissed ASC`

---

## 📦 Phase 3: Core App (Guest / Local Only)

### 3a. Expense CRUD (Isar)
- [x] Create `Expense` model (Freezed) and `ExpenseIsar` Isar schema → Run `build_runner`
- [x] Build `ExpenseLocalDatasource` (CRUD + streaming queries for monthly/60-day lists)
- [x] Build `ExpenseRepository` interface and implementation
- [x] Set up Riverpod providers (`expenseRepositoryProvider`, streams, monthly, category totals)

### 3b. UI Screens & Features
- [x] **Home Screen:**
  - [x] Progress budget bar, daily-grouped expense list, month selector, category filters, live search
  - [x] Swipe to delete (with undo snackbar), bottom navigation bar
- [x] **Add/Edit Expense Screen:**
  - [x] Numeric keyboard, category chips with haptics, datetime picker (preserving time), validation
  - [x] Edit mode with pre-fill, auto-categorize debounce (pre-filling suggested category via Gemini - note: autocompletion requires Phase 6 for active predictions)
- [x] **Budget Screen:**
  - [x] Define monthly limits per category
  - [x] Progress bars: green (<70%), amber (70-90%), red (>90%)
  - [x] Real-time updates & threshold crossing checks
- [x] **Analytics Screen:**
  - [x] 6-month spending line chart, category pie chart, daily bar chart, date filters, spending change delta
- [x] **Settings Screen:**
  - [x] Currency selector, theme toggle (light/dark/system), CSV export, notification page entry

---

## 🔑 Phase 4: Authentication (Google Sign-In)
- [x] Build `UserModel` Freezed class
- [x] Define `AuthRepository` interface (handles sign-in, sign-out, state streams)
- [x] Request `generative-language` scope during Google Sign-In authentication
- [x] *Note: Ensure `googleAccessToken` dynamically refreshes silently using `googleSignIn.currentUser?.authentication` to prevent 1-hour expiration errors.*
- [x] Create Riverpod auth providers (`authProvider`, `currentUserProvider`)
- [x] Create GoRouter guards redirecting unauthenticated users away from AI & Profile routes
- [x] Implement `LoginScreen` and `ProfileScreen` UI

---
## ☁️ Phase 5: Firestore Cloud Sync
- [x] Build `ExpenseRemoteDatasource` (Firestore CRUD sync)
- [x] Implement `SyncService.syncOnLogin(uid)`:
  - [x] *Note: Apply Last-Write-Wins (LWW) resolution for items with the same `id` using the `updatedAt` field. Keep local-only items unmerged.*
  - [x] Upload guest items with authenticated `uid` and mark local as `isSynced: true`
- [x] Update repository to write to both Isar and Firestore when signed in
- [x] Sync budget limits and detected patterns
- [x] Add cloud sync status indicators (synced, syncing, offline) to App Bar
---

## 🧠 Phase 6: Gemini AI Features
- [x] Build `GeminiDatasource` calling REST API using dynamic OAuth Bearer tokens
- [x] Implement prompt templates: monthly summaries, savings tips, forecasting, budget advice, chat context
- [x] Build **AI Insights Screen:** Summary cards, shimmering loaders, dismissible tips
- [x] Build **AI Chat Screen:** Message bubble UI, starter prompts, message histories saved to Isar
- [x] Implement **Auto-Categorize:** Debounce title keyboard input → predict category via Gemini
- [x] Implement **AI Notification Enhancement:** Generate conversational notification copies

---

## 🔔 Phase 7: Smart Notification Engine

### 7a. Notification Setup
- [x] Initialize `AwesomeNotifications` with all 6 channels (`habit_reminders`, `budget_alerts`, etc.)
- [x] Request permission dynamically (after adding the first expense)
- [x] Setup global action listeners (`@pragma("vm:entry-point")`)

### 7b. Database & Logic
- [x] Create `SpendingPatternIsar` and `NotificationLogIsar` schemas
- [x] Build **Pattern Detector:**
  - [x] Time-slot bucketing (morning, midday, afternoon, evening, night)
  - [x] Daily habit streak algorithm (3+ consecutive days, ±15% variance)
  - [x] Weekly, monthly, and anomaly detection algorithms
  - [x] *Note: Implement Category Drift using a 7-day rolling window comparison to prevent false positives.*
- [x] Build **Notification Scheduler:**
  - [x] Schedule future alarms using **Android Exact Alarms** for precise delivery
  - [x] Apply quiet hours shifts, max daily caps, and store scheduling metadata

### 7c. Interactive Background Execution
- [x] Implement `@pragma("vm:entry-point")` static Action Handlers:
  - [x] **QUICK_ADD:** *Note: Must open a new, thread-safe Isar background instance in the background isolate to save the expense.*
  - [x] **CUSTOM_ADD:** *Note: Open background Isar, read input text, write expense.*
  - [x] **SKIP_TODAY:** Mark skip event in log, reschedule for tomorrow.
- [x] Setup navigation deep links from actions (`/budgets`, `/ai`, `/add`)

### 7d. Daily Scanning & Settings
- [x] Set up WorkManager task running once daily (at midnight) to trigger full scans
- [x] Handle boot-completed broadcast (re-register WorkManager task on reboot)
- [x] Build **Notification Settings Screen:** Quiet hours picker, daily caps, list patterns (swipe to dismiss)
- [x] Build feedback loop (incrementing/decrementing confidence based on quick-add vs ignore rate)
- [x] Implement streak tracker and fire milestone streak notifications
---

## 🎨 Phase 8: UI/UX Polish & Material 3
- [x] Add smooth custom navigation slide transitions
- [x] Morphing FAB animation on Home Screen
- [x] Glassmorphism header cards with mini spending charts
- [x] Pull-to-refresh sync animations
- [x] Haptic feedback on keyboard inputs, category taps, and success events
- [x] Lottie animations: success checks, empty logs, AI sparkle loading loops
- [x] Verify accessibility, semantic labels, contrast ratios, and font scalability

---

## 🧪 Phase 9: Testing
- [x] **Unit Tests:**
  - [x] `PatternDetector` (streaks, gaps, variance margins, deduplications)
  - [x] `NotificationScheduler` (exact delivery calculation, quiet hours shift, caps)
  - [x] `SyncService` (LWW timestamp conflict merges)
- [x] **Widget & Integration Tests:**
  - [x] Home expense list rendering, budget card shake animation, settings triggers
  - [x] Exact alarm integration, notification action tap to local DB pipeline
- [x] **Manual QA Checklist:**
  - [x] Test on API 27, 30, and 34 emulators and a physical device
  - [x] Test notification buttons when app is backgrounded and completely killed
  - [ ] Verify token renewal after 1+ hours

---

## 📦 Phase 10: Build & Release
- [ ] Generate release signing keystore and configure `key.properties`
- [ ] Write ProGuard rules for Firebase, Isar, Awesome Notifications, and WorkManager
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build App Bundle: `flutter build appbundle --release`
- [ ] Upload to Google Play Console Internal Track & complete test integrations
- [ ] Set up GitHub Actions CI workflow (`.github/workflows/ci.yml`)
