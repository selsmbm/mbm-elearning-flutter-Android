import 'package:flutter/material.dart';

class ModalProgressHUD extends StatelessWidget {
  /// A required [bool]to toggle the loading animation.
  final bool inAsyncCall;

  /// A [double] value which states how opaque the loading overlay should be, defaults to 0.3
  final double opacity;

  /// A [Color] object which is assigned to the loading barrier, defaults to grey
  final Color color;

  /// A [Widget] which is shown at the center of the modal loading barrier,
  /// defaults to the standard android spinny animation.
  final Widget progressIndicator;

  /// An [Offset] object which is applied to the [progressIndicator] when specified.
  final Offset? offset;

  /// A [bool] value which sets the `loading screen can be dismissible by tapping on the loading screen` rule.
  final bool dismissible;

  /// A [Widget] which should be the the widget to be shown behind the loading barrier.
  final Widget child;

  const ModalProgressHUD({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(child: progressIndicator);
    } else {
      layOutProgressIndicator = Positioned(
        child: progressIndicator,
        left: offset!.dx,
        top: offset!.dy,
      );
    }

    return Stack(
      children: [
        child,
        Opacity(
          child: ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        layOutProgressIndicator,
      ],
    );
  }
}