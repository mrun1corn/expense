# Smart Expense Tracker — Design Specification

> **App Name:** AI Expense Tracker  
> **Platform:** Mobile (iOS / Android)  
> **Design Language:** Minimal-Functional with AI-Forward personality  
> **Last Updated:** June 2025

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Grid](#4-spacing--grid)
5. [Elevation & Shadows](#5-elevation--shadows)
6. [Component Library](#6-component-library)
7. [Screen Specifications](#7-screen-specifications)
8. [Dark Mode System](#8-dark-mode-system)
9. [Iconography](#9-iconography)
10. [Motion & Animation](#10-motion--animation)
11. [Accessibility](#11-accessibility)

---

## 1. Design Principles

| Principle | Description |
|---|---|
| **AI-Forward** | Surface AI insights proactively. AI suggestions feel like a helpful co-pilot, never intrusive. |
| **Clarity First** | Financial data is complex. Every screen reduces cognitive load through hierarchy and whitespace. |
| **Trust through Precision** | Numbers, statuses, and progress are always explicit. No ambiguity in financial states. |
| **Progressive Disclosure** | Show summaries first; details on demand. Avoid overwhelming the user. |
| **Dark-Comfortable** | Dark mode is a first-class experience — not an afterthought. Both modes feel equally intentional. |

---

## 2. Color System

### 2.1 Light Mode Palette

```
┌─────────────────────────────────────────────────────────────┐
│  BACKGROUNDS                                                │
│  bg-base        #F7F7F7   App background                   │
│  bg-surface     #FFFFFF   Cards, sheets, modals            │
│  bg-sunken      #EFEFEF   Input fields, inset areas        │
│                                                             │
│  FOREGROUNDS                                               │
│  fg-primary     #111111   Headings, primary text           │
│  fg-secondary   #6B6B6B   Subtext, labels, captions        │
│  fg-tertiary    #ABABAB   Placeholders, disabled           │
│                                                             │
│  HERO / INVERSE SURFACES                                   │
│  hero-bg        #111111   Dark header cards, CTAs          │
│  hero-fg        #FFFFFF   Text on dark surfaces            │
│  hero-fg-muted  #9B9B9B   Muted text on dark surfaces      │
│                                                             │
│  SEMANTIC COLORS                                           │
│  success        #16A34A   On Time, Settled, positive delta │
│  success-bg     #DCFCE7   Success badge background         │
│  warning        #D97706   Late, approaching limit          │
│  warning-bg     #FEF3C7   Warning badge background         │
│  danger         #DC2626   Over Budget, errors              │
│  danger-bg      #FEE2E2   Danger badge background          │
│  info           #2563EB   AI Suggested, info states        │
│  info-bg        #DBEAFE   Info badge background            │
│                                                             │
│  BRAND                                                      │
│  brand-primary  #111111   Primary buttons, active nav      │
│  brand-accent   #F0F0F0   Secondary button fills           │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Dark Mode Palette

```
┌─────────────────────────────────────────────────────────────┐
│  BACKGROUNDS                                                │
│  bg-base        #0F0F0F   App background                   │
│  bg-surface     #1C1C1C   Cards, sheets, modals            │
│  bg-sunken      #141414   Input fields, inset areas        │
│  bg-elevated    #252525   Elevated cards, tooltips         │
│                                                             │
│  FOREGROUNDS                                               │
│  fg-primary     #F2F2F2   Headings, primary text           │
│  fg-secondary   #8C8C8C   Subtext, labels, captions        │
│  fg-tertiary    #4A4A4A   Placeholders, disabled           │
│                                                             │
│  HERO / INVERSE SURFACES                                   │
│  hero-bg        #FFFFFF   Inverted hero cards (white)      │
│  hero-fg        #111111   Text on inverted surfaces        │
│  hero-fg-muted  #6B6B6B   Muted text on light surfaces     │
│  -- OR --                                                   │
│  hero-bg        #2A2A2A   Alt: deeper dark hero cards      │
│  hero-fg        #FFFFFF   Text on deep dark surfaces       │
│                                                             │
│  SEMANTIC COLORS (darkened for dark bg)                    │
│  success        #22C55E   On Time, Settled                 │
│  success-bg     #14532D   Success badge bg (dark)          │
│  warning        #FBBF24   Late, approaching limit          │
│  warning-bg     #78350F   Warning badge bg (dark)          │
│  danger         #F87171   Over Budget, errors              │
│  danger-bg      #7F1D1D   Danger badge bg (dark)           │
│  info           #60A5FA   AI Suggested                     │
│  info-bg        #1E3A5F   Info badge bg (dark)             │
│                                                             │
│  BRAND                                                      │
│  brand-primary  #FFFFFF   Primary buttons (inverted)       │
│  brand-fg       #111111   Text on primary buttons          │
│  brand-accent   #2A2A2A   Secondary button fills           │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Progress Bar Colors

| State | Light Mode Fill | Dark Mode Fill | Track (Light) | Track (Dark) |
|---|---|---|---|---|
| Normal | `#111111` | `#F2F2F2` | `#E5E5E5` | `#2A2A2A` |
| Warning (>75%) | `#D97706` | `#FBBF24` | `#FEF3C7` | `#78350F` |
| Over Budget | `#DC2626` | `#F87171` | `#FEE2E2` | `#7F1D1D` |

---

## 3. Typography

### 3.1 Type Scale

**Primary Typeface:** SF Pro (iOS) / Google Sans or Roboto (Android)  
**Monospace (numbers/amounts):** SF Mono / Roboto Mono — used exclusively for currency values

```
┌───────────────┬───────┬────────┬──────────────────────────────────────────┐
│ Token         │ Size  │ Weight │ Usage                                    │
├───────────────┼───────┼────────┼──────────────────────────────────────────┤
│ display-xl    │ 36px  │ 700    │ Hero dollar amounts ($1,500)             │
│ display-lg    │ 28px  │ 700    │ Screen totals ($1,240)                   │
│ display-md    │ 22px  │ 700    │ Section hero amounts ($1,850)            │
│ heading-lg    │ 18px  │ 700    │ Screen titles, card headers             │
│ heading-md    │ 16px  │ 600    │ Section headings, card titles           │
│ heading-sm    │ 14px  │ 600    │ List item primary labels                │
│ body-md       │ 14px  │ 400    │ Body text, descriptions                 │
│ body-sm       │ 13px  │ 400    │ Supporting text, secondary lines        │
│ caption       │ 11px  │ 400    │ Timestamps, micro-labels                │
│ caption-bold  │ 11px  │ 600    │ Status badges, tag labels               │
│ overline      │ 10px  │ 600    │ Section overlines (ALL CAPS)            │
└───────────────┴───────┴────────┴──────────────────────────────────────────┘
```

### 3.2 Type Color Pairings

```
Screen title          →  fg-primary    (100% opacity)
Section heading       →  fg-primary    (100% opacity)
Body / description    →  fg-secondary  (60–70% opacity)
Timestamp / caption   →  fg-tertiary   (40–50% opacity)
Amount (debit)        →  fg-primary    (monospace)
Amount (positive)     →  success
Overline label        →  fg-tertiary   (UPPERCASE, tracked +0.08em)
```

### 3.3 Letter Spacing

| Context | Tracking |
|---|---|
| Display numbers (amounts) | `-0.02em` — tighter for numerical weight |
| Body text | `0` — default |
| Overlines / labels | `+0.06em` — airy, editorial feel |
| Badge text | `+0.02em` |

---

## 4. Spacing & Grid

### 4.1 Base Unit

**Base unit: 4px.** All spacing is a multiple of 4.

```
4px   →  xs    (icon gaps, tight inline spacing)
8px   →  sm    (between label and value)
12px  →  md    (within components)
16px  →  lg    (card padding, section gaps)
20px  →  xl    (screen horizontal padding)
24px  →  2xl   (between major sections)
32px  →  3xl   (between screen sections)
48px  →  4xl   (hero section padding)
```

### 4.2 Screen Layout

```
┌─────────────────────────┐
│  Status Bar   (varies)  │
├─────────────────────────┤
│  Top Navigation  (56px) │
├─────────────────────────┤
│                         │
│  Content Area           │
│  H-padding: 20px        │
│  Scroll: vertical       │
│                         │
├─────────────────────────┤
│  Bottom Nav     (80px)  │
│  + safe area inset      │
└─────────────────────────┘
```

### 4.3 Card Anatomy

```
Card outer radius:   16px
Card inner padding:  16px (all sides)
Card gap (stacked):  12px
Section gap:         24px
List item height:    60px (standard transaction row)
List item padding:   12px vertical, 0 horizontal
```

---

## 5. Elevation & Shadows

### Light Mode

```css
/* Level 0 — Flat (inputs, sunken areas) */
box-shadow: none;

/* Level 1 — Cards (default surface) */
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06), 
            0 1px 2px rgba(0, 0, 0, 0.04);

/* Level 2 — Floating cards, modals */
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08),
            0 2px 4px rgba(0, 0, 0, 0.04);

/* Level 3 — Bottom sheets, overlays */
box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.10);
```

### Dark Mode

```css
/* Level 0 — Flat */
box-shadow: none;
border: 1px solid rgba(255, 255, 255, 0.05);

/* Level 1 — Cards */
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.4),
            0 1px 2px rgba(0, 0, 0, 0.3);
border: 1px solid rgba(255, 255, 255, 0.06);

/* Level 2 — Floating cards */
box-shadow: 0 4px 16px rgba(0, 0, 0, 0.6);
border: 1px solid rgba(255, 255, 255, 0.08);

/* Level 3 — Bottom sheets */
box-shadow: 0 -4px 32px rgba(0, 0, 0, 0.8);
```

> **Dark mode note:** Replace pure drop shadows with subtle borders + deeper shadows. Borders (1px, low opacity white) define surface edges since shadows lose visibility on dark backgrounds.

---

## 6. Component Library

### 6.1 Bottom Navigation Bar

```
Height: 80px (+ safe area)
Items: 4  (Home, Add, Insights, Settings)
Active item: Filled icon + label, color: brand-primary
Inactive: Outlined icon + label, color: fg-tertiary

FAB-style Add button (center):
  - Shape: Circle, 56px diameter
  - Background: brand-primary (#111111 light / #FFFFFF dark)
  - Icon: Plus, 24px, hero-fg color
  - Slightly elevated (shadow level 2)
  - Does NOT show a text label
```

**Dark Mode adjustment:**  
- Bar background: `bg-surface` (`#1C1C1C`)  
- Top border: `1px solid rgba(255,255,255,0.07)`  
- Active icon: `#FFFFFF`  
- FAB: White background, black icon

---

### 6.2 Cards

**Standard Card**
```
Background:    bg-surface
Border-radius: 16px
Padding:       16px
Shadow:        Level 1
```

**Hero / Dark Card**
```
Background:    hero-bg (#111111 light / #2A2A2A dark)
Border-radius: 16px
Padding:       20px
Text:          hero-fg (#FFFFFF)
```

**Insight / AI Card**
```
Background:    bg-sunken (#EFEFEF light / #1A1A1A dark)
Border-radius: 12px
Padding:       14px 16px
Left accent:   None (uses AI star icon instead)
```

---

### 6.3 Buttons

**Primary Button**
```
Light:  bg #111111, text #FFFFFF
Dark:   bg #FFFFFF, text #111111
Height: 52px
Radius: 14px
Font:   heading-sm, weight 600
```

**Secondary Button**
```
Light:  bg #F0F0F0, text #111111
Dark:   bg #2A2A2A, text #F2F2F2
Height: 48px
Radius: 12px
```

**Outline Button (e.g., Mark as Paid)**
```
Light:  border 1.5px #111111, bg transparent, text #111111
Dark:   border 1.5px #FFFFFF, bg transparent, text #FFFFFF
Height: 44px
Radius: 10px
```

**Ghost / Text Button**
```
No background, no border
Text color: fg-secondary
Underline on press only
```

---

### 6.4 Input Fields

```
Background:    bg-sunken
Border-radius: 12px
Height:        52px
Padding:       0 16px
Border:        1.5px solid transparent
Focus border:  1.5px solid #111111 (light) / #FFFFFF (dark)
Placeholder:   fg-tertiary
Font:          body-md
```

**Amount Input (special)**
```
Prefix "$" symbol: fg-tertiary, 22px
Value text:        display-lg, monospace
No border visible until focused
```

---

### 6.5 Badges / Tags

**AI Suggested Badge**
```
Light:  bg #DBEAFE, text #1D4ED8
Dark:   bg #1E3A5F, text #93C5FD
Radius: 6px
Padding: 2px 8px
Font:   caption-bold
Icon:   ✦ (sparkle), 10px
```

**Status Badges**

| Badge | Light BG | Light Text | Dark BG | Dark Text |
|---|---|---|---|---|
| On Time | `#DCFCE7` | `#15803D` | `#14532D` | `#4ADE80` |
| Late | `#FEF3C7` | `#B45309` | `#78350F` | `#FCD34D` |
| Pending | `#F3F4F6` | `#6B7280` | `#27272A` | `#A1A1AA` |
| Settled | `#D1FAE5` | `#065F46` | `#064E3B` | `#6EE7B7` |
| Over Budget | `#FEE2E2` | `#B91C1C` | `#7F1D1D` | `#FCA5A5` |

All badges: `border-radius: 20px`, `padding: 3px 10px`, `font: caption-bold`

---

### 6.6 Progress Bars

```
Track height:  6px
Fill height:   6px
Radius:        3px (pill)
Track color:   #E5E5E5 (light) / #2A2A2A (dark)
Fill:          See section 2.3 for state colors
Animation:     width transition 600ms ease-out on mount
```

---

### 6.7 Transaction List Item

```
Layout: Horizontal flex, align-center
Height: 60px

Left:   Icon circle (36px, bg-sunken, category icon inside)
Mid:    Stack (top: name heading-sm; bottom: category · time, caption fg-tertiary)
Right:  Amount (heading-sm, monospace, fg-primary for debit / success for credit)
```

**Dark Mode:**  
Icon circle bg: `#252525`  
Separator line: `rgba(255,255,255,0.06)`

---

### 6.8 Section Headers

```
Layout: Horizontal flex, space-between
Margin-bottom: 12px

Left:  Overline text (10px, 600 weight, ALL CAPS, fg-tertiary, tracked)
Right: "See All" link (body-sm, fg-secondary, underline on hover)
```

---

### 6.9 AI Insight Block

```
Background:    bg-sunken
Radius:        12px
Padding:       14px 16px
Icon:          ✦ sparkle, 16px, info color (left-aligned)
Title:         "AI Insight" — caption-bold, info color
Body:          body-sm, fg-secondary
Margin-top:    16px (within parent card)
```

---

### 6.10 Tab Navigation (Lend/Borrow)

```
Container:     bg-sunken, radius 12px, padding 4px
Tab height:    36px
Active tab:    bg-surface (white / #252525 dark), shadow level 1, radius 10px
Active text:   fg-primary, heading-sm
Inactive text: fg-tertiary, body-sm
Transition:    background 200ms ease
```

---

### 6.11 Stat Tiles (2-column grid)

```
Layout: 2-col grid, 12px gap
Each tile:
  Background:  bg-surface
  Radius:      12px
  Padding:     14px
  Label:       overline, fg-tertiary
  Value:       heading-lg or display-md, fg-primary
  Icon:        16px, fg-tertiary (top-left corner)
```

---

## 7. Screen Specifications

### Screen 1 — Add Transaction (Home Tab)

**Purpose:** Primary entry point for logging expenses.

**Structure:**
```
├── Top Bar
│   ├── App name "AI Expense Tracker" (heading-md)
│   └── Bell icon (notifications)
│
├── AI Prompt Banner (hero card, dark)
│   ├── ✦ "AI is ready to categorize" (caption, info color)
│   ├── "Add a new transaction" (heading-lg, white)
│   └── Subtitle (body-sm, muted white)
│
├── Input Method Tabs
│   ├── Scan Receipt (icon + label)
│   ├── Voice Input (icon + label)
│   └── Manual (icon + label) ← active, filled
│
├── Transaction Form
│   ├── Amount input ($0.00, display-lg)
│   ├── Description input (placeholder text)
│   ├── AI Category (auto-detected chip row)
│   ├── Date selector
│   └── Payment method selector
│
├── AI Insight Block
│   └── Contextual spending nudge
│
├── Recent Transactions (last 3)
│
└── "Save & Let AI Categorize" — Primary Button
```

**Dark Mode notes:**
- Hero banner: `bg #1C1C1C` with white border `rgba(255,255,255,0.08)`
- AI Prompt Banner stays dark (inverted on light, same dark on dark)
- Form fields: `bg #141414`, focus ring `#FFFFFF`
- Category chips: `bg #252525`, text `#F2F2F2`

---

### Screen 2 — AI Insights

**Purpose:** Monthly spending review powered by AI.

**Structure:**
```
├── Top Bar: "AI Insights" + subtitle
│
├── June Recap Card (hero/dark)
│   ├── "JUNE RECAP" overline
│   └── AI-generated narrative paragraph
│
├── Stats Row
│   ├── Total Spent tile
│   └── Saved vs Last Month tile
│
├── Spending Breakdown
│   ├── Section header "SPENDING BREAKDOWN"
│   └── Category rows (icon, name, %, bar)
│       Food & Drink   27% ████████████░░░░
│       Transport      13% ██████░░░░░░░░░░
│       Shopping       20% █████████░░░░░░░
│       Utilities       9% ████░░░░░░░░░░░░
│       Health          7% ███░░░░░░░░░░░░░
│       Entertainment   5% ██░░░░░░░░░░░░░░
│
├── AI Trends & Tips
│   ├── Tip 1 (icon + body)
│   └── Tip 2 (icon + body)
│
└── "Ask AI a Question" — Primary Button
```

**Dark Mode notes:**
- Recap hero card: `#1C1C1C` with slight lighter stripe at top
- Breakdown bars: white fill on `#2A2A2A` track
- Tips icons: circular `#252525` background

---

### Screen 3 — Budget Manager

**Purpose:** Set and monitor per-category spending limits.

**Structure:**
```
├── Top Bar: "Budget Manager" + Add icon
│
├── Month Overview Card (hero/dark)
│   ├── Month label "JUNE 2025"
│   ├── Budget amount "$1,500" (display-xl)
│   ├── "Spent: $1,240 · Remaining: $260" (body-sm)
│   └── Overall progress bar (full width)
│
├── "CATEGORY BUDGETS" section
│   └── Budget rows (per category):
│       [Icon] Category name   [AI Suggested badge]   ▲ warning?
│       $spent / $limit
│       Progress bar (state-colored)
│
│   States:
│   • Normal:      dark bar, under limit
│   • Warning:     amber bar, near limit
│   • Over Budget: red bar + "Over Budget" badge
│
├── AI Recommendation block
│   └── Actionable cross-category rebalancing tip
│
└── "Adjust Budgets with AI" — Primary Button
```

**Dark Mode notes:**
- Hero overview card: deep dark `#1A1A1A`
- Each budget row card: `#1C1C1C` bg, `rgba(255,255,255,0.06)` separator
- Warning bars: amber `#FBBF24`
- Over budget bars: red `#F87171`

---

### Screen 4 — Rent Tracker

**Purpose:** Track recurring rent payments; never miss a due date.

**Structure:**
```
├── Top Bar: "Rent Tracker" + Bell
│
├── Hero Rent Card (dark, with background image overlay)
│   ├── "NEXT RENT DUE" overline
│   ├── "$1,850" (display-xl)
│   ├── "July 1, 2025 · in 12 days" (body-sm, muted)
│   ├── [Mark as Paid] outline button
│   └── [⏰ Set Reminder] outline button
│
├── "PAYMENT HISTORY" section
│   └── History rows:
│       Month name   Amount   Status badge
│       Date paid
│
│   History statuses:
│   • On Time  → success green
│   • Late     → warning amber
│
├── AI Insight Block
│   └── "Paid on time 11 out of 12 months — AI suggests
│         setting an auto-reminder 5 days before due date."
│
└── "Add / Edit Rent Details" — Primary Button
```

**Dark Mode notes:**
- Hero card: `#1C1C1C` + dark overlay on background image (gradient `rgba(0,0,0,0.7)`)
- History row separators: `rgba(255,255,255,0.06)`
- On Time badge: dark green bg, bright green text
- "in 12 days" chip: `#252525` bg, white text

---

### Screen 5 — Lend & Borrow

**Purpose:** Track informal money shared with friends.

**Structure:**
```
├── Top Bar: "Lend & Borrow" + Add icon
│
├── Tab Bar
│   ├── [Lent (You're Owed)] ← active
│   └── [Borrowed (You Owe)]
│
├── Summary Stat Tiles (2-col)
│   ├── Total Lent: $420
│   └── Total Borrowed: $150
│
├── "LENT — YOU'RE OWED" section
│   └── Contact rows:
│       Avatar  Name (body)              Amount (success +)
│              Date · description        Status badge
│
│   Status states:
│   • Pending  → gray badge
│   • Settled  → green badge
│
├── AI Nudge Block
│   ├── Warning icon
│   └── "[Name] has had $X outstanding for N days —
│          AI suggests sending a friendly reminder."
│   └── [Send Reminder] secondary button
│
└── "+ Add Lend / Borrow Entry" — Primary Button
```

**Avatars:**
- 36px circle
- Light mode: colored initials on pastel bg (each person has a unique hue)
- Dark mode: same initials on muted tonal bg (lower saturation)

**Dark Mode notes:**
- Contact row hover/press: `rgba(255,255,255,0.04)` overlay
- AI nudge block: `#1A1A1A` bg, amber left-border accent `2px solid #FBBF24`

---

### Screen 6 — Dashboard (Home)

**Purpose:** At-a-glance financial snapshot for the current month.

**Structure:**
```
├── Top Bar
│   ├── "GOOD MORNING, ALEX" (overline, fg-tertiary)
│   ├── "June 2025" (heading-lg)
│   └── Sparkle / settings icon
│
├── Total Spent Card (hero/dark)
│   ├── "TOTAL SPENT" overline
│   ├── "$1,240" (display-xl)
│   ├── "of $1,500 budget" (body-sm, muted)
│   ├── Budget progress bar (full width)
│   ├── "$0 ←————————— $260 left ————→ $1,500" range
│   └── "+18% vs May" delta badge (top-right)
│
├── Quick Stats Row (2 tiles)
│   ├── SAVED: $274 (vs last month)
│   └── RENT DUE: 12 days (July 1 · $1,850)
│
├── Spending Breakdown (compact)
│   ├── Section header
│   └── Horizontal bar rows per category (5 categories)
│
├── "RECENT TRANSACTIONS" section
│   ├── See All link
│   └── Last 3 transactions
│
├── AI Insight Block
│   └── Budget warning + cross-category rebalancing tip
│
└── "+ Add Transaction" — Primary Button
```

**Delta Badge ("+18% vs May"):**
- Light: red pill, `#FEE2E2` bg, `#B91C1C` text, upward arrow icon
- Dark: `#7F1D1D` bg, `#FCA5A5` text

---

## 8. Dark Mode System

### 8.1 Switching Strategy

- **Follows system setting by default.** Respects `prefers-color-scheme`.
- **Manual override** available in Settings → Appearance (System / Light / Dark).
- Preference stored locally; synced to account if signed in.
- **No mixed modes** — entire app switches atomically; no screen-level overrides.

### 8.2 Surface Layering in Dark Mode

Dark mode uses a layered neutral system instead of pure black, preventing eye strain and creating depth:

```
Layer 0 (deepest):    #0F0F0F  — App background
Layer 1 (base):       #1C1C1C  — Standard cards
Layer 2 (elevated):   #252525  — Popovers, pickers, dropdowns
Layer 3 (highest):    #2F2F2F  — Tooltips, menus
```

> Never use pure `#000000` black as a background. It creates harsh contrast and feels "dead."

### 8.3 Dark Mode Color Substitution Table

| Role | Light Value | Dark Value | Rationale |
|---|---|---|---|
| App background | `#F7F7F7` | `#0F0F0F` | True dark, not pure black |
| Surface | `#FFFFFF` | `#1C1C1C` | Elevated above bg |
| Sunken/Input | `#EFEFEF` | `#141414` | Recessed below surface |
| Primary text | `#111111` | `#F2F2F2` | Off-white, easier on eyes |
| Secondary text | `#6B6B6B` | `#8C8C8C` | Lightened for contrast |
| Borders | none (shadow) | `rgba(255,255,255,0.07)` | Define edges in dark |
| Hero card bg | `#111111` | `#252525` | Stays dark on dark |
| Primary button | `#111111` | `#FFFFFF` | Inverted for visibility |
| Primary button text | `#FFFFFF` | `#111111` | Follows button inversion |
| Progress track | `#E5E5E5` | `#2A2A2A` | Subtle dark track |
| Progress fill | `#111111` | `#F2F2F2` | Inverted fill |

### 8.4 What Stays the Same in Dark Mode

These elements are intentionally **NOT** inverted:

- Semantic badge colors (success, warning, danger) — only backgrounds darken
- Category icons — remain their original brand color (food = orange, etc.)
- AI Suggested badge — adapts hue, not removed
- Avatar colors — desaturated slightly, not replaced
- Positive amounts (green) — same hue, slightly lighter for WCAG contrast

### 8.5 Hero Card Behavior

The dark hero card (used for total spent, rent due, etc.) handles dark mode differently:

```
Light mode: Dark card (#111111) on light app bg  →  HIGH contrast ✓
Dark mode:  Dark card (#252525) on dark app bg   →  LOW inherent contrast

Solution for dark mode:
  Option A: Hero card uses bg #2A2A2A + white border 1px rgba(255,255,255,0.1)
  Option B: Hero card inverts to white (#FFFFFF bg, #111111 text)
            ← Recommended for dashboard hero; creates visual anchor
```

### 8.6 Image Overlays in Dark Mode

Screens with photographic backgrounds (Rent Tracker hero):

```
Light mode: linear-gradient(to bottom, rgba(0,0,0,0.55), rgba(0,0,0,0.80))
Dark mode:  linear-gradient(to bottom, rgba(0,0,0,0.70), rgba(0,0,0,0.92))
```

Darker overlay in dark mode ensures text legibility without relying on ambient contrast.

### 8.7 Dark Mode Component Adjustments Summary

| Component | Light | Dark |
|---|---|---|
| Card | White, light shadow | `#1C1C1C`, subtle border |
| Input field | `#EFEFEF` bg | `#141414` bg, `rgba(255,255,255,0.08)` border |
| Progress bar track | `#E5E5E5` | `#2A2A2A` |
| Bottom nav bar | White | `#1C1C1C`, top border |
| FAB button | `#111111` bg, white icon | `#FFFFFF` bg, black icon |
| AI insight block | `#F0F0F0` bg | `#1A1A1A` bg |
| Tab switcher active | White card on `#EFEFEF` | `#252525` card on `#141414` |
| Section dividers | `rgba(0,0,0,0.07)` | `rgba(255,255,255,0.06)` |
| Skeleton loaders | `#E5E5E5` → `#F0F0F0` shimmer | `#252525` → `#2F2F2F` shimmer |

---

## 9. Iconography

### 9.1 Icon Style

- **Style:** Outlined icons with 1.5px stroke weight (default), filled for active states
- **Size defaults:** 20px (nav), 18px (list items), 16px (badges/inline), 24px (FAB)
- **Color:** Inherits `fg-secondary` unless active or semantic
- **Library:** SF Symbols (iOS) / Material Symbols Outlined (Android)

### 9.2 Category Icons

| Category | Icon | Tonal Color (Light) | Tonal Color (Dark) |
|---|---|---|---|
| Food & Drink | 🍽️ fork & knife | `#FEF9C3` bg, `#CA8A04` icon | `#713F12` bg, `#FDE047` icon |
| Transport | 🚗 car | `#DBEAFE` bg, `#2563EB` icon | `#1E3A5F` bg, `#60A5FA` icon |
| Shopping | 🛍️ bag | `#FAE8FF` bg, `#A21CAF` icon | `#4A044E` bg, `#E879F9` icon |
| Utilities | ⚡ bolt | `#FEF3C7` bg, `#D97706` icon | `#78350F` bg, `#FCD34D` icon |
| Health | ❤️ heart | `#FFE4E6` bg, `#E11D48` icon | `#881337` bg, `#FB7185` icon |
| Entertainment | 🎭 masks | `#D1FAE5` bg, `#059669` icon | `#064E3B` bg, `#34D399` icon |
| Other | ◉ circle | `#F3F4F6` bg, `#6B7280` icon | `#27272A` bg, `#9CA3AF` icon |

---

## 10. Motion & Animation

### 10.1 Easing Curves

```
ease-standard:   cubic-bezier(0.4, 0.0, 0.2, 1)   — most transitions
ease-decelerate: cubic-bezier(0.0, 0.0, 0.2, 1)   — entering elements
ease-accelerate: cubic-bezier(0.4, 0.0, 1.0, 1)   — exiting elements
ease-spring:     spring(1, 100, 10, 0)              — FAB, badge pop
```

### 10.2 Duration Scale

```
instant:   0ms     — state changes requiring no animation
fast:      100ms   — button press feedback, toggle
normal:    200ms   — tab switches, chip selection
medium:    300ms   — card expand, drawer open
slow:      500ms   — screen transitions, progress bar fill
deliberate: 700ms  — hero card entrance, modal appear
```

### 10.3 Key Animations

| Element | Animation | Duration | Easing |
|---|---|---|---|
| Screen enter | Slide up + fade (translateY 16px → 0, opacity 0 → 1) | 300ms | ease-decelerate |
| Progress bar fill | Width 0 → value% | 600ms | ease-standard |
| Badge pop (new insight) | Scale 0.8 → 1 | 200ms | ease-spring |
| Transaction added | Row slides in from right | 250ms | ease-decelerate |
| Amount update | Number morphs (counter) | 400ms | ease-standard |
| Tab switch | Active pill slides horizontally | 200ms | ease-standard |
| Bottom sheet | Translates up from bottom | 350ms | ease-decelerate |
| Dark mode toggle | Crossfade all surfaces | 200ms | ease-standard |

### 10.4 Micro-interactions

- **Button press:** Scale 0.97, duration 80ms — tactile confirmation
- **Swipe to mark paid:** Haptic + green fill animation from left
- **AI categorize:** Shimmer pulse on category chip while processing
- **Spent amount updates:** Smooth number roll (odometer effect)

### 10.5 Reduced Motion

Respect `prefers-reduced-motion: reduce`:
- Disable all transitions except opacity (fade only, 150ms)
- Keep progress bars static (fill immediately)
- No number roll animations — snap to final value

---

## 11. Accessibility

### 11.1 Color Contrast Ratios (WCAG 2.1 AA)

| Context | Requirement | Implementation |
|---|---|---|
| Body text | ≥ 4.5:1 | fg-primary on bg-surface: ~15:1 ✓ |
| Secondary text | ≥ 4.5:1 | fg-secondary on bg-surface: ~5.2:1 ✓ |
| Badge text | ≥ 4.5:1 | All badge combinations tested ✓ |
| Hero card text | ≥ 4.5:1 | White on `#111111`: 19.5:1 ✓ |
| Progress fill | ≥ 3:1 (non-text) | All fill/track combinations ≥ 3:1 ✓ |

### 11.2 Touch Targets

- Minimum touch target: **44 × 44px** (Apple HIG / Google recommendation)
- List items: 60px height — exceeds minimum
- Nav items: full column width × 56px
- FAB: 56px diameter

### 11.3 Focus States

```
Focus ring:  2px solid brand-primary, offset 2px
Dark mode:   2px solid #FFFFFF, offset 2px
Radius:      matches component radius + 2px
```

### 11.4 Screen Reader Labels

- All icon buttons: `aria-label` with descriptive text
- Amount inputs: `aria-label="Transaction amount in dollars"`
- Progress bars: `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, `aria-valuemax`
- Status badges: included in aria flow, not CSS-only

### 11.5 Dynamic Type

- All text uses relative units (sp on Android, Dynamic Type on iOS)
- Layouts tested at 80% and 150% text scale
- Number truncation: amounts use ellipsis at far right only, never truncate digits

---

## Appendix A — CSS Custom Property Reference

```css
:root {
  /* Light mode defaults */
  --bg-base:         #F7F7F7;
  --bg-surface:      #FFFFFF;
  --bg-sunken:       #EFEFEF;
  --bg-elevated:     #FFFFFF;

  --fg-primary:      #111111;
  --fg-secondary:    #6B6B6B;
  --fg-tertiary:     #ABABAB;

  --hero-bg:         #111111;
  --hero-fg:         #FFFFFF;
  --hero-fg-muted:   #9B9B9B;

  --success:         #16A34A;
  --success-bg:      #DCFCE7;
  --warning:         #D97706;
  --warning-bg:      #FEF3C7;
  --danger:          #DC2626;
  --danger-bg:       #FEE2E2;
  --info:            #2563EB;
  --info-bg:         #DBEAFE;

  --brand-primary:   #111111;
  --brand-fg:        #FFFFFF;

  --radius-sm:       8px;
  --radius-md:       12px;
  --radius-lg:       16px;
  --radius-xl:       20px;
  --radius-full:     9999px;

  --shadow-1: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
  --shadow-2: 0 4px 12px rgba(0,0,0,0.08), 0 2px 4px rgba(0,0,0,0.04);
  --shadow-3: 0 -4px 24px rgba(0,0,0,0.10);
}

[data-theme="dark"] {
  --bg-base:         #0F0F0F;
  --bg-surface:      #1C1C1C;
  --bg-sunken:       #141414;
  --bg-elevated:     #252525;

  --fg-primary:      #F2F2F2;
  --fg-secondary:    #8C8C8C;
  --fg-tertiary:     #4A4A4A;

  --hero-bg:         #252525;
  --hero-fg:         #FFFFFF;
  --hero-fg-muted:   #8C8C8C;

  --success:         #22C55E;
  --success-bg:      #14532D;
  --warning:         #FBBF24;
  --warning-bg:      #78350F;
  --danger:          #F87171;
  --danger-bg:       #7F1D1D;
  --info:            #60A5FA;
  --info-bg:         #1E3A5F;

  --brand-primary:   #FFFFFF;
  --brand-fg:        #111111;

  --shadow-1: 0 1px 3px rgba(0,0,0,0.4), 0 1px 2px rgba(0,0,0,0.3);
  --shadow-2: 0 4px 16px rgba(0,0,0,0.6);
  --shadow-3: 0 -4px 32px rgba(0,0,0,0.8);
}
```

---

## Appendix B — Design Checklist

Before shipping any screen, verify:

- [ ] Tested in light mode on white background
- [ ] Tested in dark mode on `#0F0F0F` background
- [ ] All text meets WCAG AA contrast ratios
- [ ] Touch targets ≥ 44px
- [ ] Progress bars have text fallback (X of Y)
- [ ] AI badges have correct sparkle icon
- [ ] Status badges use correct semantic color (not just color — also shape/icon for colorblind users)
- [ ] Amounts use monospace numeral rendering
- [ ] Empty states designed for each section
- [ ] Skeleton loader designed for async data
- [ ] Error state designed for failed data fetch
- [ ] Reduced motion variant validated
- [ ] Screen reader labels on all interactive elements
- [ ] Bottom safe area inset respected
- [ ] Tested at 150% system text scale

---

*End of Design Specification*