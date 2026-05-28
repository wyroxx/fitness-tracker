import 'dart:async';

import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppToastType { info, success, error, warning }

void showAppToast(
  BuildContext context, {
  required String message,
  AppToastType type = AppToastType.info,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _AppToast(
        message: message,
        type: type,
        onDismissed: () {
          if (entry.mounted) {
            entry.remove();
          }
        },
      );
    },
  );

  overlay.insert(entry);
}

class _AppToast extends StatefulWidget {
  const _AppToast({
    required this.message,
    required this.type,
    required this.onDismissed,
  });

  final String message;
  final AppToastType type;
  final VoidCallback onDismissed;

  @override
  State<_AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<_AppToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    unawaited(_showAndHide());
  }

  Future<void> _showAndHide() async {
    await _controller.forward();
    await Future<void>.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    return switch (widget.type) {
      AppToastType.info => AppColors.primary,
      AppToastType.success => const Color(0xFF2E7D32),
      AppToastType.error => const Color(0xFFD32F2F),
      AppToastType.warning => const Color(0xFFF57C00),
    };
  }

  IconData get _icon {
    return switch (widget.type) {
      AppToastType.info => CupertinoIcons.info_circle_fill,
      AppToastType.success => Icons.check,
      AppToastType.error => Icons.close,
      AppToastType.warning => CupertinoIcons.exclamationmark,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
