import 'package:flutter/material.dart';

class BottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClose;
  final String? title;

  const BottomSheetWrapper({
    super.key,
    required this.child,
    this.onClose,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom +
        20;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),
          ),

          // Header
          if (title != null || onClose != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey.withValues(
                          alpha: 0.2,
                        ), // Updated
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}
