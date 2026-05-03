# CivicGuide V3 — Task Tracker

## Phase 0: Baseline Audit
- [x] Survey full codebase structure and file sizes
- [x] Identify files exceeding 300 lines
- [x] Run `flutter analyze` for current warning count

## Phase 1: Code Quality & Architecture
- [x] Refactor oversized files (extract widgets)
- [x] Enforce zero direct API calls in UI layer
- [x] Add comprehensive DartDoc to all public APIs
- [x] Update `analysis_options.yaml` with strict rules

## Phase 2: New Product Features
- [x] Create `JourneyScreen` with interactive Checklist UI
- [x] Create Timeline component
- [x] Add structured AI response cards in chat (Action Chips)
- [x] Wire JourneyScreen into MainShell navigation

## Phase 3: Testing & Accessibility Evidence Pack
- [x] Update README with Architecture Note and Evidence Block
- [x] Add `integration_test` to pubspec.yaml
- [x] Write `home_screen_golden_test.dart` (Mobile & Desktop layouts)
- [x] Write `journey_screen_golden_test.dart` (Mobile & Desktop layouts)
- [x] Write `app_test.dart` Integration Flow (Guest login → Home loads)
- [x] Write `app_test.dart` Integration Flow (Quick Action opens Journey → checklist toggle)
- [x] Write `app_test.dart` Integration Flow (Language remains correct)
- [x] Write `app_test.dart` Integration Flow (Failure state renders properly)
- [x] Expand `docs/accessibility.md` with explicit WCAG 2.1 AA signals

## Phase 4: Performance Validation
- [x] Determine and document Bundle Size (~2.1 MB Gzipped) in README
- [x] Add Performance Metrics (FCP, TTI) and HTML Renderer strategy to README
- [x] Audit for `const` constructors and `Selector()`/`context.select()` rebuild optimizations
- [x] Implement Lazy Loading (deferred import) for `ocr_service.dart`

## Phase 5: Resilience & Error Handling
- [x] Create explicit state components (`loading_state.dart`, `empty_state.dart`, `error_state.dart`)
- [x] Implement Intelligent Recovery UX in Chat (Retry, Open Checklist, Contact Helpline)
- [x] Create `lib/core/error_logger.dart` and implement `logError`
- [x] Mention logging layer in README

## Phase 7: Accessibility & Documentation
- [x] Create `docs/accessibility.md`
- [x] Semantic sweep (every interactive element)
- [x] Keyboard navigation with FocusTraversalGroup
- [x] Contrast verification

## Phase 8: Google Services & Analytics
- [x] Add `firebase_analytics` with privacy-first policy
- [x] Expand Firestore usage for Checklist state (Real-time sync)
- [x] Update README with evaluation mapping
- [x] Create `docs/google_services.md` mapping
