# Codebase Simplification Tasks

## 1. Foundation & Cleanup
- [ ] Create `lib/widgets/` directory for shared components.
- [ ] Fix deprecated `Color.withOpacity` usages (replace with `.withValues(alpha: ...)`).
- [ ] Verify imports and assets (remove unused).

## 2. Logic Refactoring
- [ ] Move transaction math (income/expense/balance calculations) from `HomeScreen` to `TransactionProvider`.

## 3. Shared UI Components
- [ ] Create `BottomSheetWrapper` widget (standardized decoration, handle bar, header).
- [ ] Create `DeleteDismissibleBackground` widget (standardized red background with icon).
- [ ] Create reusable `showDeleteConfirmationDialog` function.
- [ ] Standardize TextField usage (create `CustomTextField` or unify on `CupertinoTextField`).
- [ ] Refactor `AddTransactionSheet` date picker logic into a reusable method/widget.

## 4. Screen Refactoring
- [ ] Refactor `AddTransactionSheet` to use `BottomSheetWrapper` and shared Date Picker.
- [ ] Refactor `AddCategorySheet` to use `BottomSheetWrapper`.
- [ ] Refactor `HomeScreen` to use `DeleteDismissibleBackground`, `showDeleteConfirmationDialog`, and new Provider logic.
- [ ] Refactor `CategoryScreen` to use `DeleteDismissibleBackground` and `showDeleteConfirmationDialog`.

## 5. Verification
- [ ] Run `flutter analyze` to ensure zero lints.
- [ ] Manual testing of refactored screens to ensure no regression.
