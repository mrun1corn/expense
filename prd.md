# Smart Expense Tracker — Complete Build TODO (v2)

> Flutter Android app · Firebase Auth + Firestore · Gemini AI · Smart Notification Engine · Material 3

---

## Table of Contents

1. [Project Vision](#1-project-vision)
2. [Full Tech Stack](#2-full-tech-stack)
3. [Architecture Overview](#3-architecture-overview)
4. [Folder Structure](#4-folder-structure)
5. [Data Models](#5-data-models)
6. [Flutter Dependencies](#6-flutter-dependencies)
7. [🧠 Smart Notification System — Deep Dive](#7-smart-notification-system--deep-dive)
8. [Phase 0 — Environment Setup](#phase-0--environment-setup)
9. [Phase 1 — Flutter Project Bootstrap](#phase-1--flutter-project-bootstrap)
10. [Phase 2 — Firebase Setup](#phase-2--firebase-setup)
11. [Phase 3 — Core App (Guest / Local Only)](#phase-3--core-app-guest--local-only)
12. [Phase 4 — Authentication](#phase-4--authentication-google-sign-in)
13. [Phase 5 — Firestore Cloud Sync](#phase-5--firestore-cloud-sync)
14. [Phase 6 — Gemini AI Features](#phase-6--gemini-ai-features)
15. [Phase 7 — Smart Notification Engine (Build)](#phase-7--smart-notification-engine-build)
16. [Phase 8 — UI/UX Polish](#phase-8--uiux-polish--material-3)
17. [Phase 9 — Testing](#phase-9--testing)
18. [Phase 10 — Build & Release](#phase-10--build--release)
19. [Feature Flag Matrix](#feature-flag-matrix)
20. [Quick Reference Commands](#quick-reference-commands)

---

## 1. Project Vision

A smart, modern expense tracker that works as a **standalone offline app** by default, and upgrades to a **cloud-synced, AI-powered financial assistant** when the user signs in with Google.

The app learns your spending habits over time and **proactively reminds you to log expenses** at the exact time you usually spend — with one-tap quick-add buttons right from the notification itself.

| Mode | Features |
|---|---|
| 🔓 Guest | Full CRUD, budgets, charts, smart notifications — 100% local |
| 🔑 Signed In | Everything + cloud sync, multi-device, Gemini AI insights, AI chat |

---

## 2. Full Tech Stack

### Frontend
| Layer | Choice | Notes |
|---|---|---|
| Framework | **Flutter 3.22+** stable | Dart 3.4+ |
| UI System | **Material 3** | Dynamic color, adaptive components |
| State Management | **Riverpod 2** + `riverpod_annotation` | Code-gen providers |
| Navigation | **GoRouter 13+** | Declarative, deep-link ready |
| Local DB | **Isar 3** | Embedded NoSQL, fast queries on device |
| Charts | **fl_chart 0.68+** | Line, bar, pie |
| Date/Time | **intl** + **table_calendar** | Locale + calendar picker |

### Backend / Cloud
| Layer | Choice | Notes |
|---|---|---|
| Auth | **Firebase Auth** + Google Sign-In | OAuth 2.0 with generative-language scope |
| Database | **Cloud Firestore** | Real-time sync, built-in offline support |
| Storage | **Firebase Storage** | Receipt images |
| Analytics | **Firebase Analytics** | Usage events |
| Crashlytics | **Firebase Crashlytics** | Error reporting |

### AI
| Layer | Choice | Notes |
|---|---|---|
| LLM | **Gemini 2.0 Flash** | Via `google_generative_ai` package |
| Auth method | Google OAuth token from Firebase Sign-In | No API key in app binary |
| Scope | `https://www.googleapis.com/auth/generative-language` | Added to GoogleAuthProvider |

### Notification System
| Layer | Choice | Notes |
|---|---|---|
| Notification Plugin | **awesome_notifications** | Action buttons, inline reply, background/killed support |
| Background Tasks | **workmanager** | Daily pattern detection when app is closed |
| Pattern Engine | Custom Dart (on-device) | No server needed — runs locally on Isar data |

### Dev Tooling
| Tool | Purpose |
|---|---|
| **FlutterFire CLI** | Firebase wiring |
| **build_runner** | Riverpod + Isar + Freezed codegen |
| **Freezed + json_serializable** | Immutable data models |
| **very_good_analysis** | Strict lint rules |
| **mocktail** | Unit test mocking |
| **GitHub Actions** | CI — test → build APK |

---

## 3. Architecture Overview

```
lib/
├── core/            ← Theme, router, utils, constants
├── features/
│   ├── auth/        ← Google Sign-In, Firebase Auth state
│   ├── expenses/    ← CRUD (local Isar + remote Firestore)
│   ├── budgets/     ← Budget limits per category
│   ├── analytics/   ← Charts and spending reports
│   ├── ai_insights/ ← Gemini integration (sign-in gated)
│   ├── notifications/ ← Smart Notification Engine
│   └── settings/    ← Theme, currency, notification prefs
└── main.dart
```

**Data flow (Clean Architecture):**
```
UI (Widgets)
   ↕  watches
Providers (Riverpod)
   ↕  calls
Repository Interface
   ↕  implemented by
Local Repo (Isar) ←→ Remote Repo (Firestore)
                           ↕
                     SyncService (merge on login)

[Background]
WorkManager → PatternDetectionTask → PatternRepository (Isar)
                                           ↓
                                   NotificationScheduler
                                           ↓
                               awesome_notifications (fires at right time)
```

---

## 4. Folder Structure

```
smart_expense_tracker/
├── android/
│   └── app/
│       ├── google-services.json
│       ├── src/main/AndroidManifest.xml   ← notification permissions
│       └── build.gradle
├── assets/
│   ├── animations/         ← Lottie JSON (success, empty, ai-thinking)
│   ├── icons/              ← Category SVG icons
│   └── images/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── category_constants.dart
│   │   │   └── notification_channels.dart   ← channel IDs and names
│   │   ├── extensions/
│   │   │   ├── datetime_ext.dart
│   │   │   └── double_ext.dart              ← currency formatting
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── color_schemes.dart
│   │   └── utils/
│   │       └── currency_utils.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_repository_impl.dart
│   │   │   │   └── firebase_auth_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   └── models/user_model.dart
│   │   │   └── presentation/
│   │   │       ├── auth_provider.dart
│   │   │       ├── login_screen.dart
│   │   │       └── profile_screen.dart
│   │   ├── expenses/
│   │   │   ├── data/
│   │   │   │   ├── local/
│   │   │   │   │   ├── expense_local_datasource.dart
│   │   │   │   │   └── isar/expense_isar.dart
│   │   │   │   ├── remote/
│   │   │   │   │   └── expense_remote_datasource.dart
│   │   │   │   ├── expense_repository_impl.dart
│   │   │   │   └── sync_service.dart
│   │   │   ├── domain/
│   │   │   │   ├── expense_repository.dart
│   │   │   │   ├── models/expense.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_expense.dart
│   │   │   │       ├── delete_expense.dart
│   │   │   │       ├── get_expenses.dart
│   │   │   │       └── update_expense.dart
│   │   │   └── presentation/
│   │   │       ├── providers/expense_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── home_screen.dart
│   │   │       │   ├── add_expense_screen.dart
│   │   │       │   └── expense_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── expense_card.dart
│   │   │           ├── expense_list.dart
│   │   │           └── category_chip.dart
│   │   ├── budgets/
│   │   │   └── ...  (same structure)
│   │   ├── analytics/
│   │   │   ├── presentation/
│   │   │   │   ├── analytics_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── spending_chart.dart
│   │   │   │       ├── category_pie_chart.dart
│   │   │   │       └── monthly_bar_chart.dart
│   │   │   └── providers/analytics_provider.dart
│   │   ├── ai_insights/
│   │   │   ├── data/
│   │   │   │   └── gemini_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── ai_insight.dart
│   │   │   │   └── prompt_builder.dart
│   │   │   └── presentation/
│   │   │       ├── ai_chat_screen.dart
│   │   │       ├── insight_card.dart
│   │   │       └── ai_provider.dart
│   │   ├── notifications/           ← Smart Notification Engine
│   │   │   ├── data/
│   │   │   │   ├── isar/
│   │   │   │   │   ├── spending_pattern_isar.dart
│   │   │   │   │   └── notification_log_isar.dart
│   │   │   │   ├── pattern_repository_impl.dart
│   │   │   │   └── notification_log_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── spending_pattern.dart
│   │   │   │   │   └── notification_log.dart
│   │   │   │   ├── pattern_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── detect_patterns.dart
│   │   │   │       ├── schedule_habit_notifications.dart
│   │   │   │       └── dismiss_pattern.dart
│   │   │   ├── engine/
│   │   │   │   ├── pattern_detector.dart   ← Core algorithm
│   │   │   │   ├── notification_scheduler.dart
│   │   │   │   └── background_task.dart    ← WorkManager entry point
│   │   │   └── presentation/
│   │   │       ├── notification_settings_screen.dart
│   │   │       └── providers/notification_provider.dart
│   │   └── settings/
│   │       └── ...
│   └── main.dart
├── test/
│   ├── unit/
│   │   └── notifications/
│   │       ├── pattern_detector_test.dart
│   │       └── notification_scheduler_test.dart
│   ├── widget/
│   └── integration/
├── pubspec.yaml
├── analysis_options.yaml
└── .env
```

---

## 5. Data Models

### Expense
```dart
@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,           // UUID
    required String userId,       // empty string for guest
    required double amount,
    required String currency,
    required ExpenseCategory category,
    required DateTime date,       // full timestamp (date + time)
    required String title,
    String? note,
    String? receiptImageUrl,
    @Default(false) bool isSynced,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}
```

### SpendingPattern (core notification model)
```dart
enum PatternType {
  dailyHabit,      // Same amount, same time window, N consecutive days
  weeklyRecurring, // Same amount+category, same day of week, N weeks
  monthlyFixed,    // Same amount, same day of month (rent, subscriptions)
  categoryDrift,   // Spending in category trending upward week-over-week
  anomalySpike,    // Single expense unusually large vs. category average
}

@freezed
class SpendingPattern with _$SpendingPattern {
  const factory SpendingPattern({
    required String id,
    required PatternType type,
    required ExpenseCategory category,
    required double typicalAmount,
    double? amountTolerance,      // ±% acceptable variance (default 15%)
    int? timeSlotHour,            // hour of day the pattern peaks (e.g. 18 = 6pm)
    int? timeSlotWindowMinutes,   // how wide the time window is (e.g. 60)
    int? dayOfWeek,               // 1=Mon...7=Sun for weekly patterns
    int? dayOfMonth,              // for monthly patterns
    required int occurrences,     // how many times this was observed
    required double confidence,   // 0.0–1.0 (occurrences / possible slots)
    required DateTime firstSeen,
    required DateTime lastSeen,
    required DateTime detectedAt,
    @Default(false) bool notificationScheduled,
    @Default(false) bool isDismissed,
    @Default(false) bool isConfirmed, // user tapped "Yes, remind me"
    DateTime? nextScheduledAt,
    int? notificationId,
  }) = _SpendingPattern;
}
```

### NotificationLog
```dart
@freezed
class NotificationLog with _$NotificationLog {
  const factory NotificationLog({
    required String id,
    required String patternId,    // which pattern triggered this
    required NotificationType type,
    required DateTime firedAt,
    required UserResponse response, // tapped | dismissed | quickAdded | customAdded | ignored
    double? addedAmount,          // if user quick-added or custom-added
  }) = _NotificationLog;
}

enum NotificationType {
  habitReminder, weeklyPattern, monthlyPattern,
  budgetWarning, budgetExceeded, inactivityNudge,
  aiInsightReady, weeklySummary, streak,
}

enum UserResponse { tapped, dismissed, quickAdded, customAdded, ignored }
```

### Budget
```dart
@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,
    required ExpenseCategory category,
    required double limitAmount,
    required String currency,
    required int month,
    required int year,
    @Default(0.0) double spentAmount,
    required DateTime createdAt,
  }) = _Budget;
}
```

### Firestore document paths
```
users/{uid}/
  expenses/{expenseId}
  budgets/{budgetId}
  patterns/{patternId}       ← sync patterns so they survive reinstall
  insights/{insightId}
  profile/settings
```

---

## 6. Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Firebase
  firebase_core: ^2.30.1
  firebase_auth: ^4.19.6
  cloud_firestore: ^4.17.2
  firebase_storage: ^11.7.6
  firebase_analytics: ^10.10.6
  firebase_crashlytics: ^3.5.6
  google_sign_in: ^6.2.1

  # AI
  google_generative_ai: ^0.4.3

  # Local database
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.3

  # Notifications (use awesome_notifications — NOT compatible with flutter_local_notifications)
  awesome_notifications: ^0.9.3+1
  awesome_notifications_fcm: ^0.9.3+1   # if FCM push needed later

  # Background tasks (for pattern detection when app is closed)
  workmanager: ^0.5.2

  # Models
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

  # UI
  fl_chart: ^0.68.0
  table_calendar: ^3.1.2
  lottie: ^3.1.2
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  flutter_slidable: ^3.1.1
  intl: ^0.19.0
  uuid: ^4.4.0
  gap: ^3.0.1
  flex_color_scheme: ^7.3.1

  # Utils
  collection: ^1.18.0           # groupBy, sorted, etc.
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  isar_generator: ^3.1.0+1
  very_good_analysis: ^6.0.0
  mocktail: ^1.0.3
  flutter_launcher_icons: ^0.13.1
```

---

## 7. Smart Notification System — Deep Dive

> This is the most sophisticated part of the app. Read this section fully before writing any code.

### 7.1 The Core Idea

When a user spends **💵30 at 6–7 PM for 3 consecutive days**, the app detects this as a **daily habit pattern** and:

1. Schedules a smart notification for ~6:45 PM on day 4
2. The notification shows: *"You usually spend around 💵30 at this time. Log it?"*
3. Action buttons on the notification itself:
   - **[✓ Add 💵30]** — one-tap adds the expense without opening the app
   - **[✏ Custom amount]** — inline text field in the notification (Android 7+)
   - **[✗ Skip today]** — dismisses and records the skip

This entire interaction can happen **without the user opening the app**.

---

### 7.2 Pattern Detection Algorithm

The `PatternDetector` class in `lib/features/notifications/engine/pattern_detector.dart` runs on local Isar data. No network required.

#### Step 1 — Load & preprocess

```
Load all expenses from last 60 days (Isar query, sorted by date DESC)
Filter out expenses with amount = 0 or category = 'other'
Map each expense to a PatternCandidate:
  { date, dayOfWeek, hour, amount, category, title }
```

#### Step 2 — Time slot bucketing

Divide the day into named slots for grouping:
```
morning:   06:00–10:59
midday:    11:00–13:59
afternoon: 14:00–17:59
evening:   18:00–20:59   ← your 6–7 PM example falls here
night:     21:00–23:59
```

#### Step 3 — Daily habit detection (your exact use case)

```
For each (timeSlot, category) combination:
  1. Get all expenses in that slot across last 30 days
  2. Group by calendar date
  3. Compute median amount for that group
  4. Find longest consecutive-day streak where:
       - expense exists in that time slot
       - amount is within ±15% of the median
  5. If streak >= 3 AND at least 3 of the last 7 days match:
       → Create SpendingPattern(type: dailyHabit, confidence: streak/7)
```

#### Step 4 — Weekly recurring detection

```
For each (dayOfWeek, category) combination:
  1. Get expenses on that weekday over last 8 weeks
  2. Count how many of those 8 weeks had an expense in that category
  3. Compute median amount
  4. If count >= 3 weeks (confidence > 0.375):
       → Create SpendingPattern(type: weeklyRecurring)
```

#### Step 5 — Monthly fixed detection (subscriptions / rent)

```
For each (dayOfMonth ± 2 days, category, amount ± 5%) combination:
  1. Look back 4 months
  2. Count matching months
  3. If count >= 2:
       → Create SpendingPattern(type: monthlyFixed)
       → Set nextScheduledAt = next occurrence of that day-of-month
```

#### Step 6 — Category drift detection

```
For each category:
  thisWeekTotal = sum of expenses this week
  lastWeekTotal = sum of expenses last week
  twoWeeksAgoTotal = sum from 2 weeks ago
  
  If thisWeekTotal > lastWeekTotal * 1.3 AND thisWeekTotal > twoWeeksAgoTotal * 1.3:
    → Create SpendingPattern(type: categoryDrift)
    → Trigger immediate notification (not scheduled)
```

#### Step 7 — Anomaly spike detection

```
For each category:
  historicalAvg = average single-expense amount over last 60 days
  today's expenses in category:
    if any expense > historicalAvg * 3.0:
      → Create SpendingPattern(type: anomalySpike)
      → Fire notification immediately
```

#### Step 8 — Confidence scoring & deduplication

```
Sort detected patterns by confidence DESC
Discard duplicates (same type + category + timeSlot = keep highest confidence)
Discard patterns where isDismissed = true (unless lastSeen > 14 days ago, re-check)
Save new/updated patterns to Isar
```

---

### 7.3 Notification Channels

Define in `lib/core/constants/notification_channels.dart`:

| Channel Key | Name | Importance | Use |
|---|---|---|---|
| `habit_reminders` | Habit Reminders | High | Daily/weekly spending pattern nudges |
| `budget_alerts` | Budget Alerts | High | 70%, 90%, 100% budget threshold |
| `ai_insights` | AI Insights | Default | Gemini results ready |
| `weekly_summary` | Weekly Summary | Default | Sunday digest |
| `streak_badge` | Achievements | Low | Streaks and milestones |
| `inactivity_nudge` | Gentle Reminders | Low | 2-day no-logging nudge |

---

### 7.4 Notification Designs

#### A. Daily Habit Reminder
```
📍 Title:  "Habitual spend — 💵30"
   Body:   "You usually spend around 💵30 on Food at this time (6 PM). Log it?"
   
   [✓ Add 💵30]  [✏ Enter amount]  [✗ Skip today]
   
   → "Add 💵30" silently calls addExpense() via background isolate, shows
     "✅ Added 💵30 to Food" confirmation notification
   → "Enter amount" opens inline text input (awesome_notifications InputField)
   → "Skip today" calls dismissForToday() — pattern stays alive for tomorrow
```

#### B. Weekly Pattern Reminder
```
📍 Title:  "Weekly Food expense"
   Body:   "Every Friday you usually spend on Food (~💵250). Did you today?"
   
   [Yes, add 💵250]  [Different amount]  [Not today]
```

#### C. Monthly Fixed Reminder
```
📍 Title:  "Monthly payment due"
   Body:   "You usually pay ~💵1,500 around the 5th of each month (Utilities). Log it?"
   
   [Add 💵1,500]  [Custom]  [Dismiss]
```

#### D. Budget Warning (80%)
```
📍 Title:  "Food budget at 80%"
   Body:   "You've spent 💵800 of your 💵1,000 Food budget. 3 weeks left in July."
   
   [View Budget]  [Dismiss]
   
   → Tapping opens BudgetScreen scrolled to that category
```

#### E. Category Drift Alert
```
📍 Title:  "Transport spending up 40%"
   Body:   "You've spent 💵680 on Transport this week vs 💵480 last week."
   
   [See Details]  [Got it]
```

#### F. Inactivity Nudge (48 hours, no log)
```
📍 Title:  "Still tracking? 👀"
   Body:   "It's been 2 days since your last expense. Quick log?"
   
   [Add expense]  [Remind later]
   
   → "Remind later" reschedules for +12 hours
   → Fired max once every 3 days to avoid being annoying
```

#### G. AI Insight Ready (signed-in users)
```
📍 Title:  "Gemini found 3 money tips 💡"
   Body:   "Based on this month's spending, you could save ~💵300 on Food. Tap to see."
   
   [View Insights]
```

#### H. Logging Streak
```
📍 Title:  "🔥 7-day streak!"
   Body:   "You've logged expenses every day for a week. Keep it up!"
   
   [View streak]
```

---

### 7.5 When Pattern Detection Runs

| Trigger | When | What it does |
|---|---|---|
| **App foreground** | App opens | Light pass: check if any patterns need updating |
| **After adding expense** | Every expense save | Re-evaluate relevant patterns immediately |
| **Background daily task** | Midnight (WorkManager) | Full pattern scan — reschedule next day's notifications |
| **After sign-in** | Login event | Merge cloud patterns with local + re-run detection |
| **Budget crossed 70/90/100%** | Realtime after save | Fire immediate budget notification |
| **No expense for 48h** | Checked by WorkManager | Fire inactivity nudge (max once per 3 days) |

---

### 7.6 User Control over Notifications

In **Settings → Notifications**:
- Global on/off toggle
- Per-channel on/off toggles
- "Quiet hours" — no notifications between X:XX PM and Y:XX AM
- "Max per day" — cap at 1, 2, or 3 notifications per day
- View all detected patterns with ability to delete/disable each
- Per-pattern: "Always remind", "Never remind", "Ask me each time"

---

### 7.7 Notification Feedback Loop (Learning)

Every user interaction with a notification is logged to `NotificationLog`:

```
User taps [Add 💵30]     → response: quickAdded    → confidence +0.1
User taps [Skip today]  → response: dismissed      → (no confidence change)
User ignores 3x in a row → response: ignored x3   → confidence -0.2, consider disabling
User taps [Custom: 💵45] → response: customAdded   → update typicalAmount toward 45
```

After 7+ notification interactions for a pattern:
- If quickAdded rate > 60%: pattern is `isConfirmed = true`, notify more assertively
- If ignored rate > 50%: pause pattern for 7 days, then re-evaluate
- Feed confirmation/rejection data back to Gemini (signed-in) to improve AI insight accuracy

---

### 7.8 Gemini-Enhanced Pattern Descriptions (signed-in users)

When a pattern is detected for signed-in users, call Gemini with context:

```
Prompt:
"User has a daily spending pattern:
  Category: Food
  Typical amount: 💵32
  Time: 6–7 PM
  Occurred: 5 of last 7 days
  Their food budget this month: 💵1500, spent so far: 💵920

Write a single friendly, conversational notification body (max 80 chars) that:
1. Acknowledges the habit without judgment
2. Suggests they log it now
3. Mentions how it impacts their monthly budget if relevant"

→ Response: "Looks like your evening snack! 💵32 would bring Food to 63% of budget."
```

This replaces the generic notification body with a personalized Gemini-written one.

---

## Phase 0 — Environment Setup

- [ ] Install **Flutter 3.22+** stable: `flutter upgrade`
- [ ] Install **Android Studio** (Hedgehog+) with Android SDK 34
- [ ] Install **FlutterFire CLI**: `dart pub global activate flutterfire_cli`
- [ ] Install **Firebase CLI**: `npm install -g firebase-tools` then `firebase login`
- [ ] Create **Google Cloud project** (Firebase will create one, or use existing)
  - [ ] Enable **Generative Language API**
  - [ ] Enable **Cloud Firestore API**
  - [ ] Enable **Firebase Authentication API**
- [ ] Create **Firebase project** at `console.firebase.google.com`
  - [ ] Register Android app (package name: `com.yourname.smart_expense_tracker`)
  - [ ] Enable **Google Sign-In** under Authentication → Sign-in method
  - [ ] Create **Firestore Database** (start in test mode)
- [ ] Set up Git + GitHub repo
- [ ] Create `.gitignore` — include `google-services.json`, `.env`, `*.keystore`

---

## Phase 1 — Flutter Project Bootstrap

- [ ] `flutter create smart_expense_tracker --org com.yourname --platforms android`
- [ ] Update `pubspec.yaml` with all dependencies from section 6 (Note: Add dependency overrides for `analyzer` if Isar 3.x conflicts with modern Dart code-gen tools on Flutter 3.22+)
- [ ] Run `flutter pub get`
- [ ] Add `analysis_options.yaml` with `very_good_analysis`
- [ ] Configure `android/app/build.gradle`:
  - [ ] `minSdkVersion 23`
  - [ ] `targetSdkVersion 34`
  - [ ] `compileSdkVersion 34`
  - [ ] `multiDexEnabled true`
- [ ] Add notification permissions to `AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.VIBRATE"/>
  <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
  <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <!-- WorkManager -->
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  ```
- [ ] Add `workmanager` CallbackDispatcher to AndroidManifest:
  ```xml
  <service android:name="be.tramckrijte.workmanager.BackgroundWorker"
      android:exported="false"
      android:permission="android.permission.BIND_JOB_SERVICE" />
  ```
- [ ] Set up **GoRouter** in `lib/core/router/app_router.dart`:
  - [ ] Routes: `/`, `/add`, `/expense/:id`, `/analytics`, `/ai`, `/login`, `/profile`, `/settings`, `/settings/notifications`, `/patterns`
  - [ ] Auth redirect guard — only AI/profile require auth
  - [ ] Deep-link from notification tap → route to correct screen
- [ ] Set up **Material 3 theme** with dynamic color + light/dark support
- [ ] Set up **Riverpod** with `ProviderScope` wrapping `MaterialApp`
- [ ] Initialize **Isar** — create `IsarService` singleton opened at app start
- [ ] Configure **app icon**: `flutter_launcher_icons`
- [ ] Configure **splash screen**

---

## Phase 2 — Firebase Setup

- [ ] Run `flutterfire configure` → generates `firebase_options.dart`, downloads `google-services.json`
- [ ] Initialize Firebase in `main.dart`
- [ ] Enable **Firebase Crashlytics** — add Gradle plugin + initialize in main
- [ ] Enable **Firebase Analytics**
- [ ] Set **Firestore security rules**:
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /users/{userId}/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
  ```
- [ ] Create **Firestore composite indexes**:
  - [ ] `expenses` collection: `date DESC` + `category ASC`
  - [ ] `expenses` collection: `date DESC` (monthly filter)
  - [ ] `patterns` collection: `confidence DESC` + `isDismissed ASC`

---

## Phase 3 — Core App (Guest / Local Only)

> The full expense tracker must work completely without any login.

### 3a. Expense CRUD

- [ ] Create `Expense` Freezed model → run `build_runner`
- [ ] Create `ExpenseIsar` Isar schema → run `build_runner`
- [ ] Build `ExpenseLocalDatasource` with:
  - [ ] `Stream<List<Expense>> watchAll()`
  - [ ] `Future<void> add(Expense e)`
  - [ ] `Future<void> update(Expense e)`
  - [ ] `Future<void> delete(String id)`
  - [ ] `Future<List<Expense>> getByMonth(int month, int year)`
  - [ ] `Future<List<Expense>> getLast60Days()` ← needed by pattern detector
  - [ ] `Future<Map<ExpenseCategory, double>> getCategoryTotals(DateTime from, DateTime to)`
- [ ] Build `ExpenseRepository` interface + `ExpenseRepositoryImpl`
- [ ] Build Riverpod providers:
  - [ ] `expenseRepositoryProvider`
  - [ ] `expensesStreamProvider` — realtime watch
  - [ ] `monthlyExpensesProvider(month, year)`
  - [ ] `categoryTotalsProvider(from, to)`
  - [ ] `totalThisMonthProvider`
  - [ ] `last60DaysProvider` ← used by pattern engine

### 3b. Home Screen

- [ ] Monthly summary card: total spent + remaining budget bar
- [ ] FAB → `AddExpenseScreen`
- [ ] Recent expenses list (grouped by day with headers)
- [ ] Swipe to delete (flutter_slidable) with undo snackbar
- [ ] Month selector
- [ ] Category filter chips
- [ ] Search bar (live filter by title)
- [ ] Empty state (Lottie animation)
- [ ] Bottom navigation: Home | Analytics | AI (locked badge) | Settings

### 3c. Add/Edit Expense Screen

- [ ] Amount input: numeric keyboard, large display, auto-focus
- [ ] Title field
- [ ] Category picker: horizontal scroll with icon chips, haptic on tap
- [ ] Date/time picker (defaults to now — **preserve time, not just date**) ← critical for pattern detection
- [ ] Optional note
- [ ] Optional receipt photo (camera / gallery) — save to local path
- [ ] Validation: amount > 0, title required
- [ ] Edit mode: pre-fill from `expense` route param
- [ ] Delete button on edit with confirmation dialog
- [ ] After save: trigger `PatternDetector.onExpenseAdded(expense)` ← updates patterns

### 3d. Budget System

- [ ] `Budget` Freezed model + Isar schema
- [ ] `BudgetScreen`: set limit per category per month
- [ ] `BudgetProgressWidget`: color-coded progress bar (green < 70%, amber 70–90%, red > 90%)
- [ ] On every expense save: recompute `spentAmount` for that category's budget
- [ ] Trigger `NotificationScheduler.onBudgetUpdated()` → fires alert if threshold crossed

### 3e. Analytics Screen

- [ ] Monthly spending line chart — last 6 months (`fl_chart`)
- [ ] Category breakdown pie chart + legend
- [ ] Daily spending bar chart — current month
- [ ] Date range filter (this month / 3 months / custom)
- [ ] Biggest category callout card
- [ ] vs. last month delta with % change badge

### 3f. Settings Screen

- [ ] Default currency selector
- [ ] Theme: light / dark / system
- [ ] Export CSV (`csv` + `share_plus`)
- [ ] Notifications settings entry point (→ Phase 7)
- [ ] "Sign in to unlock AI" banner (guest only)

---

## Phase 4 — Authentication (Google Sign-In)

- [ ] `UserModel` Freezed class: `uid`, `email`, `displayName`, `photoUrl`
- [ ] `AuthRepository` interface:
  - [ ] `Stream<User?> authStateChanges`
  - [ ] `Future<UserModel?> signInWithGoogle()`
  - [ ] `Future<void> signOut()`
  - [ ] `String? get googleAccessToken` (Note: Ensure this dynamically resolves a valid token, requesting a silent token refresh via `googleSignIn.currentUser?.authentication` if expired/expiring)
- [ ] `FirebaseAuthDatasource` — request `generative-language` scope during sign-in:
  ```dart
  final googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/generative-language',
  ]);
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  // store googleAuth.accessToken for Gemini API calls
  ```
- [ ] `authProvider` Riverpod — wraps auth state stream
- [ ] `currentUserProvider` — derives `UserModel?` from auth state
- [ ] `LoginScreen`: hero illustration + Google button + "Continue as Guest" link
- [ ] `ProfileScreen`: avatar, name, email, sign-out, storage used, detected patterns count
- [ ] GoRouter auth guard: only AI and Profile routes require auth
- [ ] On sign-in: run `SyncService.syncOnLogin(uid)` and `PatternDetector.runFullScan()`
- [ ] On sign-out: clear `googleAccessToken` from Riverpod state, keep local data

---

## Phase 5 — Firestore Cloud Sync

- [ ] `ExpenseRemoteDatasource` — Firestore CRUD:
  - [ ] `Stream<List<Expense>> watchAll(String uid)`
  - [ ] `Future<void> upsert(String uid, Expense e)`
  - [ ] `Future<void> delete(String uid, String id)`
  - [ ] `Future<List<Expense>> fetchAll(String uid)`
- [ ] `SyncService.syncOnLogin(uid)`:
  - [ ] Fetch all Firestore expenses for `uid`
  - [ ] Fetch all local Isar expenses (`userId == ''` = guest data)
  - [ ] Merge: Apply Last-Write-Wins (LWW) resolution for items with the same `id` using the `updatedAt` field. Keep local-only items unmerged.
  - [ ] Upload unsynced local items with user's `uid`
  - [ ] Mark all local items as `isSynced: true`
- [ ] Update `ExpenseRepositoryImpl`:
  - [ ] Signed in → write to both Isar + Firestore
  - [ ] Guest → write to Isar only
  - [ ] Firestore snapshot listener syncs deltas into Isar in real-time
- [ ] Sync same logic for **Budgets** and **Patterns**
- [ ] Sync indicator in app bar (cloud icon: synced / syncing / offline)
- [ ] Offline badge when Firestore unreachable

---

## Phase 6 — Gemini AI Features

> Gated behind `currentUser != null`. Show "Sign in" prompt when accessing as guest.

### 6a. Gemini Service

- [ ] `GeminiDatasource` using OAuth Bearer token (from `googleAccessToken`):
  ```dart
  final response = await http.post(
    Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent'
    ),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({ 'contents': [{ 'parts': [{'text': prompt}] }] }),
  );
  ```
- [ ] `geminiServiceProvider` — auto-rebuilds on auth state change
- [ ] Handle 401 → prompt re-sign-in (token expired after ~1h)
- [ ] Handle rate limit gracefully with retry backoff

### 6b. Prompt Templates (`prompt_builder.dart`)

- [ ] **Monthly summary**: last 30 days by category → 3-sentence narrative
- [ ] **Savings tips**: category totals + budget limits → top 2 actionable tips
- [ ] **Prediction**: 3 months of totals → next month estimate
- [ ] **Pattern description**: detected pattern → personalized notification body (see section 7.8)
- [ ] **Budget advice**: current patterns → smart budget suggestions per category
- [ ] **Chat**: free-form question with last 30 days data injected as system context

### 6c. AI Insights Screen

- [ ] Monthly AI Summary card (auto-generated, regenerated if > 6h old)
- [ ] Insight cards: tip | warning | prediction — each dismissible
- [ ] Pull-to-refresh: regenerates insights
- [ ] Shimmer loading skeleton while Gemini generates
- [ ] Insight cards with icon (lightbulb / warning / chart-up)

### 6d. AI Chat Screen

- [ ] Chat bubble UI (user right, Gemini left)
- [ ] Every message injects last 30 days of expense data as context
- [ ] Starter prompts: "Where can I cut costs?", "Compare this vs last month", "Suggest budget limits"
- [ ] Typing indicator animation while Gemini responds
- [ ] Chat history saved to Isar (per `uid`)
- [ ] Clear chat button

### 6e. Smart Features via Gemini

- [ ] **Auto-categorize**: as user types title in AddExpenseScreen, debounce 500ms → ask Gemini to suggest category → pre-fill chip (user can override)
- [ ] **Budget recommendation**: "Suggest budgets for me" button → Gemini analyzes 3 months of data, returns suggested limits per category
- [ ] **Pattern-enhanced notifications**: Gemini writes personalized notification body (see section 7.8)

---

## Phase 7 — Smart Notification Engine (Build)

### 7a. awesome_notifications Setup

- [ ] Add `awesome_notifications: ^0.9.3+1` to pubspec
- [ ] Initialize in `main.dart` **before** `runApp()`:
  ```dart
  await AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(channelKey: 'habit_reminders',  channelName: 'Habit Reminders',  defaultColor: Colors.teal,   importance: NotificationImportance.High),
      NotificationChannel(channelKey: 'budget_alerts',    channelName: 'Budget Alerts',    defaultColor: Colors.orange, importance: NotificationImportance.High),
      NotificationChannel(channelKey: 'ai_insights',      channelName: 'AI Insights',      defaultColor: Colors.purple, importance: NotificationImportance.Default),
      NotificationChannel(channelKey: 'weekly_summary',   channelName: 'Weekly Summary',   defaultColor: Colors.blue,   importance: NotificationImportance.Default),
      NotificationChannel(channelKey: 'streak_badge',     channelName: 'Achievements',     defaultColor: Colors.amber,  importance: NotificationImportance.Low),
      NotificationChannel(channelKey: 'inactivity_nudge', channelName: 'Gentle Reminders', defaultColor: Colors.grey,   importance: NotificationImportance.Low),
    ],
  );
  ```
- [ ] Request permission at appropriate moment (first expense added, not on app launch)
- [ ] Set up `AwesomeNotifications().setListeners()`:
  - [ ] `onNotificationCreatedMethod`
  - [ ] `onNotificationDisplayedMethod`
  - [ ] `onDismissActionReceivedMethod` → log `UserResponse.dismissed`
  - [ ] `onActionReceivedMethod` → handle all button actions

### 7b. Isar Schemas for Notification Engine

- [ ] Create `SpendingPatternIsar` Isar collection schema → run `build_runner`
- [ ] Create `NotificationLogIsar` Isar collection schema → run `build_runner`
- [ ] `PatternRepository` interface + `PatternRepositoryImpl`

### 7c. Pattern Detector

- [ ] Build `PatternDetector` class in `lib/features/notifications/engine/pattern_detector.dart`
- [ ] Implement `Future<List<SpendingPattern>> detectAll(List<Expense> last60Days)`:
  - [ ] Step 1: time-slot bucketing (section 7.2 step 2)
  - [ ] Step 2: daily habit detection (consecutive days, ±15% amount tolerance)
  - [ ] Step 3: weekly recurring detection (N of last 8 weeks)
  - [ ] Step 4: monthly fixed detection (same day ± 2 days, same amount ± 5%, 2+ months)
  - [ ] Step 5: category drift detection (30%+ increase in spending over a 7-day rolling window compared to the prior 7-day rolling window, preventing false positives at the start of a calendar week)
  - [ ] Step 6: anomaly spike detection (3× category average)
  - [ ] Step 7: confidence scoring + deduplication
- [ ] Implement `Future<void> onExpenseAdded(Expense e)`:
  - [ ] Quick re-check only patterns relevant to `e.category` and `e.date.hour`
  - [ ] Update existing patterns' `occurrences`, `lastSeen`, `confidence`
  - [ ] Create new pattern if threshold met
  - [ ] Call `NotificationScheduler.rescheduleForPattern(pattern)` for affected patterns
- [ ] Implement `Future<void> runFullScan()` ← called by WorkManager and on login

### 7d. Notification Scheduler

- [ ] Build `NotificationScheduler` in `lib/features/notifications/engine/notification_scheduler.dart`
- [ ] Implement `Future<void> scheduleHabitReminder(SpendingPattern p)`:
  - [ ] Compute next fire time: today at `p.timeSlotHour + 15 minutes` (middle of window)
  - [ ] If that time has already passed today, schedule for tomorrow
  - [ ] If `quiet hours` overlap, shift to after quiet hours end
  - [ ] If max-per-day cap reached, queue for next available slot
  - [ ] Use `AwesomeNotifications().createNotification()` with `NotificationSchedule` (using Exact Alarms to ensure precision delivery, bypassing Android Doze mode)
  - [ ] Store `notificationId` back onto the pattern in Isar
- [ ] Implement action buttons for habit reminder:
  ```dart
  actionButtons: [
    NotificationActionButton(
      key: 'QUICK_ADD',
      label: 'Add 💵${p.typicalAmount.toStringAsFixed(0)}',
      actionType: ActionType.SilentAction,  // no app open
    ),
    NotificationActionButton(
      key: 'CUSTOM_ADD',
      label: 'Custom amount',
      actionType: ActionType.SilentBackgroundAction,
      requireInputText: true,   // inline text input
      inputPlaceholder: 'Enter amount...',
    ),
    NotificationActionButton(
      key: 'SKIP_TODAY',
      label: 'Skip today',
      actionType: ActionType.DismissAction,
      isDangerousOption: false,
    ),
  ]
  ```
- [ ] Implement `Future<void> fireImmediateBudgetAlert(Budget b, double percent)`:
  - [ ] Build budget notification body with remaining amount
  - [ ] Action buttons: [View Budget] [Dismiss]
- [ ] Implement `Future<void> scheduleBudgetCheck(Budget b)`:
  - [ ] Schedule daily check at midnight: recompute `spentAmount`, fire if threshold newly crossed
- [ ] Implement `Future<void> scheduleInactivityNudge()`:
  - [ ] Schedule for `lastExpenseDate + 48h`
  - [ ] Cancel and reschedule whenever a new expense is added
  - [ ] Cancel if notification already fired within 3 days
- [ ] Implement `Future<void> cancelNotification(int notificationId)`:
  - [ ] Call `AwesomeNotifications().cancel(notificationId)`
  - [ ] Update Isar pattern record

### 7e. Notification Action Handlers

- [ ] In `AwesomeNotifications().setListeners()`, handle `onActionReceivedMethod`:
  ```dart
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    switch (action.buttonKeyPressed) {
      case 'QUICK_ADD':
        // Parse amount + category from action.payload
        // Open a new thread-safe background Isar instance in this isolate (main UI thread's instance is not accessible)
        // Create Expense and save to Isar (background isolate, no UI)
        // Fire confirmation notification: "✅ Added 💵30 to Food"
        // Log to NotificationLog: response = quickAdded
        break;
      case 'CUSTOM_ADD':
        final customAmount = double.tryParse(action.buttonKeyInput ?? '');
        if (customAmount != null && customAmount > 0) {
          // Same as QUICK_ADD but with customAmount (opening a thread-safe Isar background instance)
          // Update pattern.typicalAmount toward this value (rolling avg)
          // Log: response = customAdded, addedAmount = customAmount
        }
        break;
      case 'SKIP_TODAY':
        // Log: response = dismissed
        // Reschedule same notification for tomorrow at same time
        break;
    }
  }
  ```
- [ ] Handle `'VIEW_BUDGET'` action → deep link to `/budgets` via GoRouter
- [ ] Handle `'VIEW_INSIGHTS'` action → deep link to `/ai` route
- [ ] Handle `'ADD_EXPENSE'` action (inactivity) → deep link to `/add`
- [ ] Ensure all handlers are annotated `@pragma("vm:entry-point")` (required for background execution)

### 7f. WorkManager Background Task

- [ ] Initialize `Workmanager` in `main.dart`:
  ```dart
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  ```
- [ ] Register periodic task (runs once daily):
  ```dart
  await Workmanager().registerPeriodicTask(
    'pattern-detection-daily',
    'patternDetectionTask',
    frequency: const Duration(hours: 24),
    initialDelay: Duration.zero,
    constraints: Constraints(networkType: NetworkType.not_required),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
  ```
- [ ] Implement `callbackDispatcher`:
  ```dart
  @pragma('vm:entry-point')
  void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      if (taskName == 'patternDetectionTask') {
        // Open Isar in background isolate
        // Load last 60 days of expenses
        // Run PatternDetector.detectAll()
        // Run NotificationScheduler.rescheduleAll()
        // Check inactivity
        // Close Isar
      }
      return Future.value(true);
    });
  }
  ```
- [ ] Handle `RECEIVE_BOOT_COMPLETED` broadcast: re-register WorkManager task after device reboot

### 7g. Notification Settings Screen

- [ ] Route: `/settings/notifications`
- [ ] Global on/off toggle (calls `AwesomeNotifications().requestPermissionToSendNotifications()`)
- [ ] Per-channel toggle list
- [ ] Quiet hours start/end time pickers
- [ ] Max notifications per day selector: 1 / 2 / 3 / unlimited
- [ ] "Detected Patterns" section:
  - [ ] List all `SpendingPattern` records from Isar (sorted by confidence DESC)
  - [ ] Each row: category icon + pattern description + confidence badge
  - [ ] Swipe to disable a pattern (sets `isDismissed = true`)
  - [ ] "Always remind" / "Never" toggle per pattern
- [ ] "Notification History" link → shows last 30 notification logs

### 7h. Notification Feedback Loop

- [ ] After 7+ interactions with any pattern, run feedback evaluation:
  - [ ] `quickAdded + customAdded > 60%` of interactions → set `isConfirmed = true`
  - [ ] `ignored > 50%` of interactions → set `isDismissed = true`, schedule re-eval in 14 days
  - [ ] Track rolling `typicalAmount` as weighted average: `newAvg = oldAvg * 0.7 + latestAmount * 0.3`
- [ ] Feed confirmed patterns to Gemini (signed-in) with: "User confirmed this habit. Improve the notification copy."
- [ ] Store updated patterns back to Isar (and Firestore if signed in)

### 7i. Logging Streak Notifications

- [ ] Track `currentStreakDays` (consecutive days with at least one expense) in Isar `StreakRecord`
- [ ] On every expense save: check if streak increments (new calendar day vs. last expense day)
- [ ] Fire `streak_badge` notification at: 3, 7, 14, 30, 60, 100 days
- [ ] Display streak count in home screen header with fire emoji

---

## Phase 8 — UI/UX Polish & Material 3

### Navigation & Structure
- [ ] Material 3 `NavigationBar` (bottom):
  - [ ] Home | Analytics | AI (with lock badge when guest) | Settings
- [ ] Smooth page transitions via `CustomTransitionPage`
- [ ] FAB on Home → morphs into AddExpenseScreen with hero animation

### Home Screen Refinements
- [ ] Glassmorphism summary card at top: monthly total + mini donut chart
- [ ] Pull-to-refresh (syncs Firestore if signed in)
- [ ] Smart notification badge on home: "3 patterns detected → Tap to review"

### Notification Engine Feedback in UI
- [ ] After pattern is detected, show an in-app banner (once):
  - [ ] "We noticed you spend ~💵30 on Food around 6 PM. Want reminders?"
  - [ ] [Yes, remind me] [No thanks]
  - [ ] "Yes" → sets `isConfirmed = true`, strengthens notification scheduling
- [ ] "Patterns" section in Profile/Settings showing detected habits visually

### Micro-interactions
- [ ] Amount field: tap → full-screen numeric keypad (banking app style)
- [ ] Category picker: haptic feedback on select
- [ ] Expense added: Lottie success animation
- [ ] AI generating: animated sparkle/pulse
- [ ] Budget exceeded: shake animation on budget card
- [ ] Streak milestone: confetti burst (Lottie)

### Accessibility
- [ ] All elements have semantic labels
- [ ] Minimum 48×48 dp tap targets
- [ ] Color contrast verified in both light/dark
- [ ] Font scaling tested

---

## Phase 9 — Testing

### Unit Tests
- [ ] `PatternDetector` — all 6 detection algorithms with edge cases:
  - [ ] Exactly 3 consecutive days (minimum threshold)
  - [ ] Gap in the middle (streak resets correctly)
  - [ ] Amount variance just inside/outside ±15% tolerance
  - [ ] Multiple overlapping patterns (deduplication)
- [ ] `NotificationScheduler`:
  - [ ] Correct time calculation (past time today → tomorrow)
  - [ ] Quiet hours shift works
  - [ ] Max-per-day cap enforced
- [ ] `SyncService` — merge conflict logic
- [ ] `PromptBuilder` — prompts contain correct data
- [ ] `BudgetCalculator` — threshold detection
- [ ] Feedback loop — `typicalAmount` rolling average

### Widget Tests
- [ ] `HomeScreen` renders expense list correctly
- [ ] `AddExpenseScreen` validates and calls repository
- [ ] `NotificationSettingsScreen` toggles correctly
- [ ] AI screen shows locked state for guests

### Integration Tests
- [ ] Full add expense → pattern detection → notification scheduled
- [ ] Quick-add from notification → expense appears in list
- [ ] Sign in → sync → sign out → local data intact
- [ ] Budget 90% → notification fires

### Manual QA Checklist
- [ ] Test on API 27, 30, 34 emulators
- [ ] Test with app in foreground, background, and killed
- [ ] Test quick-add button on notification when app is killed
- [ ] Test with no internet connection
- [ ] Test quiet hours — notification does not fire
- [ ] Test max-per-day cap — extra notifications queued, not dropped
- [ ] Test WorkManager task fires at midnight (use debug mode to trigger)
- [ ] Test pattern dismissal survives app restart
- [ ] Test Gemini token expiry → re-sign-in flow

---

## Phase 10 — Build & Release

- [ ] Generate release keystore: `keytool -genkey -v -keystore upload-keystore.jks`
- [ ] Configure `android/key.properties`
- [ ] Configure `android/app/build.gradle` for release signing
- [ ] Add ProGuard rules for Firebase, Isar, awesome_notifications, WorkManager:
  ```
  -keep class com.google.firebase.** { *; }
  -keep class io.isar.** { *; }
  -keep class me.carda.awesomeNotifications.** { *; }
  -keep class be.tramckrijte.workmanager.** { *; }
  ```
- [ ] Test release build on physical device: `flutter build apk --release`
- [ ] Build App Bundle: `flutter build appbundle --release`
- [ ] **Google Play Console**:
  - [ ] Add release keystore SHA-1 to Firebase
  - [ ] Add SHA-1 to Google Cloud Console → OAuth credentials (or Google Sign-In breaks in release)
  - [ ] Upload to Internal Testing track first
  - [ ] Test Google Sign-In on the internal test build before publishing
- [ ] **GitHub Actions CI** (`.github/workflows/ci.yml`):
  ```yaml
  on: [push]
  jobs:
    test-and-build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: subosito/flutter-action@v2
          with: { flutter-version: '3.22.x' }
        - run: flutter pub get
        - run: dart run build_runner build --delete-conflicting-outputs
        - run: flutter test
        - run: flutter analyze
        - run: flutter build apk --release
        - uses: actions/upload-artifact@v4
          with: { path: build/app/outputs/flutter-apk/app-release.apk }
  ```
- [ ] Enable **Firebase App Distribution** for beta testing

---

## Feature Flag Matrix

| Feature | Guest | Signed In |
|---|---|---|
| Add/edit/delete expenses | ✅ | ✅ |
| Category budgets | ✅ | ✅ |
| Analytics charts | ✅ | ✅ |
| Export CSV | ✅ | ✅ |
| **Smart habit notifications** | ✅ | ✅ |
| **Quick-add from notification** | ✅ | ✅ |
| **Custom amount from notification** | ✅ | ✅ |
| **Pattern detection engine** | ✅ | ✅ |
| **Budget threshold alerts** | ✅ | ✅ |
| **Inactivity nudge** | ✅ | ✅ |
| **Logging streak** | ✅ | ✅ |
| Cloud sync (Firestore) | ❌ | ✅ |
| Multi-device access | ❌ | ✅ |
| Receipt cloud upload | Local only | ☁ Cloud |
| Sync patterns across devices | ❌ | ✅ |
| **AI monthly summary** | ❌ | ✅ |
| **AI savings tips** | ❌ | ✅ |
| **AI chat assistant** | ❌ | ✅ |
| **Gemini-personalized notification copy** | ❌ | ✅ |
| **Auto-categorize with Gemini** | ❌ | ✅ |
| **Budget suggestions via Gemini** | ❌ | ✅ |
| **Weekly AI digest notification** | ❌ | ✅ |

---

## Quick Reference Commands

```bash
# Create project
flutter create smart_expense_tracker --org com.yourname --platforms android

# Firebase wiring (once)
flutterfire configure

# Code generation (after any model/provider/schema change)
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Run on connected device
flutter run

# Run tests
flutter test

# Code analysis
flutter analyze

# Build release APK
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release
```

---

*Last updated: May 2026 · Stack: Flutter 3.22 · Firebase 10 · Gemini 2.0 Flash · awesome_notifications · WorkManager · Material 3*
