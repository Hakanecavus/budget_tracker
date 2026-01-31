# Codebase Simplification Tasks

## 1. Foundation & Cleanup
- [x] Create `lib/widgets/` directory for shared components.
- [x] Fix deprecated `Color.withOpacity` usages (replace with `.withValues(alpha: ...)`).
- [x] Verify imports and assets (remove unused).

## 2. Logic Refactoring
- [x] Move transaction math (income/expense/balance calculations) from `HomeScreen` to `TransactionProvider`.

## 3. Shared UI Components
- [x] Create `BottomSheetWrapper` widget (standardized decoration, handle bar, header).
- [x] Create `DeleteDismissibleBackground` widget (standardized red background with icon).
- [x] Create reusable `showDeleteConfirmationDialog` function.
- [x] Standardize TextField usage (create `CustomTextField` or unify on `CupertinoTextField`).
- [x] Refactor `AddTransactionSheet` date picker logic into a reusable method/widget.

## 4. Screen Refactoring
- [x] Refactor `AddTransactionSheet` to use `BottomSheetWrapper` and shared Date Picker.
- [x] Refactor `AddCategorySheet` to use `BottomSheetWrapper`.
- [x] Refactor `HomeScreen` to use `DeleteDismissibleBackground`, `showDeleteConfirmationDialog`, and new Provider logic.
- [x] Refactor `CategoryScreen` to use `DeleteDismissibleBackground` and `showDeleteConfirmationDialog`.

## 5. Verification
- [x] Run `flutter analyze` to ensure zero lints.
- [x] Manual testing of refactored screens to ensure no regression.
