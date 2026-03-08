import 'dart:async';

import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, required this.next});

  final Widget next;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  late final Animation<double> _slide = Tween<double>(begin: 10, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tracking = Tween<double>(begin: 22, end: 10).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_autoContinue());
  }

  Future<void> _autoContinue() async {
    await Future<void>.delayed(const Duration(milliseconds: 1250));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => widget.next));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skip() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => widget.next));
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.displayLarge;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _skip,
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final opacity = _fade.value;
                final dy = _slide.value;
                final spacing = _tracking.value;
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: Text(
                      'NIRAI',
                      textAlign: TextAlign.center,
                      style: (base ?? const TextStyle(fontSize: 64)).copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        letterSpacing: spacing,
                        height: 1.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
