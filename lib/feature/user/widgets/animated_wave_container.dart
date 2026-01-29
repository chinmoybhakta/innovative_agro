import 'package:flutter/material.dart';

class AnimatedWaveContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const AnimatedWaveContainer({
    super.key,
    required this.child,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final waveY = size.height * 0.7;
    final waveHeight = 25.0;

    // Rectangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, waveY);

    // Bottom wave
    path.quadraticBezierTo(
      size.width * 0.75,
      waveY - waveHeight,
      size.width * 0.5,
      waveY,
    );

    path.quadraticBezierTo(
      size.width * 0.25,
      waveY + waveHeight,
      0,
      waveY,
    );

    // Close shape
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

