import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../routing/router.dart';

class Info {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackbarMessage(BuildContext context,
          {required String message,
          String? label,
          String actionLabel = "Close",
          void Function()? onCloseTapped,
          Duration duration = const Duration(seconds: 3)}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 2,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label,
                    ),
                  Text(
                    message,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () {
                if (onCloseTapped != null) {
                  onCloseTapped();
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                }
              },
              child: Text(
                actionLabel,
              ),
            )
          ],
        ),
        duration: duration,
      ),
    );
  }

  static FutureOr showInAppNotification(
      {Duration? duration,
      void Function()? onTap,
      String? title,
      String? content}) {
    Duration notificationDuration = duration ?? const Duration(seconds: 10);
    BuildContext? context = GlobalRouter.I.context;
    if (context == null) {
      return null;
    }
    return InAppNotification.show(
      child: AppNotification(
        title: title ?? '',
        content: content ?? '',
        duration: notificationDuration,
      ),
      context: context,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        InAppNotification.dismiss(context: context);
      },
      duration: notificationDuration,
    );
  }
}

class AppNotification extends StatelessWidget {
  final Duration duration;
  final String title;
  final String content;
  final void Function()? onTap;

  const AppNotification(
      {super.key,
      this.duration = const Duration(seconds: 10),
      this.onTap,
      this.title = "Title",
      this.content = "Lorem ipsum bacon ham turkey roast"});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actionsPadding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.orangeAccent,
      title: Row(
        children: [
          Text(
            title,
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text(content)],
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onTap != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        if (onTap != null) {
                          onTap!();
                        }
                        InAppNotification.dismiss(context: context);
                      },
                      child: const Text("Sign out"),
                    )),
              ),
            DurationProgressBar(duration: duration),
          ],
        )
      ],
    );
  }
}

class DurationProgressBar extends StatefulWidget {
  final Duration duration;

  const DurationProgressBar({super.key, required this.duration});

  @override
  State<DurationProgressBar> createState() => _DurationProgressBarState();
}

class _DurationProgressBarState extends State<DurationProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = _controller.value;
        return LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          backgroundColor: Colors.green,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }
}
