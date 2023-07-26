import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class DialpadButton extends StatefulWidget {
  final String number;

  DialpadButton({required this.number});

  @override
  _DialpadButtonState createState() => _DialpadButtonState();
}

class _DialpadButtonState extends State<DialpadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      // onTapCancel: _handleTapUp,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(widget.number),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 500),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}