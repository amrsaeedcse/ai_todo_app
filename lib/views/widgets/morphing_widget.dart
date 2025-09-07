import 'package:flutter/material.dart';

class MorphingWidget extends StatefulWidget {
  final Widget child; // أي Widget تحطه هنا
  final AnimationController? controller; // تحكم خارجي لو حابب
  final Duration duration;

  MorphingWidget({
    required this.child,
    this.controller,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  _MorphingWidgetState createState() => _MorphingWidgetState();
}

class _MorphingWidgetState extends State<MorphingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _internalController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;

  bool _useExternalController = false;

  @override
  void initState() {
    super.initState();
    _useExternalController = widget.controller != null;
    _internalController =
        widget.controller ??
        AnimationController(vsync: this, duration: widget.duration);

    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _internalController, curve: Curves.easeInOut),
    );

    _radiusAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(parent: _internalController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _internalController, curve: Curves.easeInOut),
    );

    if (!_useExternalController) {
      _internalController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {}); // ممكن تعمل حاجة بعد الانتهاء
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _internalController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _sizeAnimation.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radiusAnimation.value),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  void start() {
    _internalController.forward();
  }

  void reset() {
    _internalController.reset();
  }

  @override
  void dispose() {
    if (!_useExternalController) _internalController.dispose();
    super.dispose();
  }
}
