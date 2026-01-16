import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NotificationOverlay {
  static final NotificationOverlay _instance = NotificationOverlay._internal();
  factory NotificationOverlay() => _instance;
  NotificationOverlay._internal();

  OverlayEntry? _overlayEntry;
  Timer? _dismissTimer;

  void show(BuildContext context, {required String title, required String message, IconData icon = Icons.notifications_active}) {
    _dismissTimer?.cancel();
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) => _NotificationBanner(
        title: title,
        message: message,
        icon: icon,
        onDismiss: hide,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _dismissTimer = Timer(const Duration(seconds: 5), () {
      hide();
    });
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _dismissTimer?.cancel();
  }
}

class _NotificationBanner extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onDismiss;

  const _NotificationBanner({
    required this.title,
    required this.message,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<_NotificationBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: MedColors.patPrimary.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MedColors.patPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: MedColors.patPrimary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MedColors.textMain),
                      ),
                      Text(
                        widget.message,
                        style: const TextStyle(fontSize: 14, color: MedColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () {
                    _controller.reverse().then((_) => widget.onDismiss());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
