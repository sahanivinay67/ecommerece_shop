import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

class VadaPavLogo extends StatefulWidget {
  final double size;

  const VadaPavLogo({Key? key, required this.size}) : super(key: key);

  @override
  State<VadaPavLogo> createState() => _VadaPavLogoState();
}

class _VadaPavLogoState extends State<VadaPavLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _centerImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // 3 seconds for full rotation
    )..repeat();

    _loadImage();
  }

  Future<void> _loadImage() async {
    // Load image from assets
    // Make sure to add your image to pubspec.yaml under assets
    try {
      final ByteData data = await rootBundle.load(
        'assets/images/burning_pav.png',
      );
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      setState(() {
        _centerImage = frameInfo.image;
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _centerImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: VadaPavLogoPainter(
              centerImage: _centerImage,
              rotationAngle: _controller.value * 2 * math.pi,
            ),
          ),
        );
      },
    );
  }
}

class VadaPavLogoPainter extends CustomPainter {
  final ui.Image? centerImage;
  final double rotationAngle;

  VadaPavLogoPainter({this.centerImage, required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw glow effect
    _drawGlow(canvas, center, radius);

    // Draw outer decorative border (with rotation)
    _drawDecorativeBorder(canvas, center, radius);

    // Draw main circle background
    _drawMainCircle(canvas, center, radius);

    // Draw geometric pattern background
    _drawGeometricPattern(canvas, center, radius);

    // Draw center image
    _drawCenterImage(canvas, center, radius);

    // Draw inner gold ring
    _drawInnerRing(canvas, center, radius);

    // Draw text
    _drawText(canvas, center, radius);

    // Draw "SINCE 2005" badge
    _drawSinceBadge(canvas, center, radius);
  }

  void _drawGlow(Canvas canvas, Offset center, double radius) {
    final glowPaint =
        Paint()
          ..color = const Color(0xFF4DD0E1).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(center, radius * 0.95, glowPaint);
  }

  void _drawDecorativeBorder(Canvas canvas, Offset center, double radius) {
    // Draw thick dark border (stationary)
    final borderPaint =
        Paint()
          ..color = const Color(0xFF2D3E3F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 26;

    canvas.drawCircle(center, radius * 0.92, borderPaint);

    // Save canvas state before rotation
    canvas.save();

    // Rotate only the decorative segments
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);

    // Two colors for alternating pattern
    const color1 = Color(0xFFFF9100); // Orange
    const color2 = Color(0xFFFF3D00); // Red-Orange

    // Draw decorative segments
    final segmentCount = 24;
    final segmentAngle = (2 * math.pi) / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final angle = i * segmentAngle - math.pi / 2;

      // Alternate between two colors based on segment index
      Color segmentColor = (i % 2 == 0) ? color1 : color2;

      final segmentPaint =
          Paint()
            ..color = segmentColor
            ..style = PaintingStyle.fill;

      final path = Path();
      final outerRadius = radius * 0.95;
      final innerRadius = radius * 0.85;
      final segmentWidth = segmentAngle * 0.7;

      path.moveTo(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        angle,
        segmentWidth,
        false,
      );
      path.lineTo(
        center.dx + outerRadius * math.cos(angle + segmentWidth),
        center.dy + outerRadius * math.sin(angle + segmentWidth),
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        angle + segmentWidth,
        -segmentWidth,
        false,
      );
      path.close();

      canvas.drawPath(path, segmentPaint);
    }

    // Restore canvas state
    canvas.restore();
  }

  void _drawMainCircle(Canvas canvas, Offset center, double radius) {
    final circlePaint =
        Paint()
          ..color = const Color(0xFF3D4E4F)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.82, circlePaint);
  }

  void _drawGeometricPattern(Canvas canvas, Offset center, double radius) {
    final paint =
        Paint()
          ..color = const Color(0xFFFF8A3D)
          ..style = PaintingStyle.fill;

    final innerRadius = radius * 0.47;
    final outerRadius = radius * 0.7;
    final wedgeAngle = math.pi * 0.2;

    // LEFT wedge
    _drawCurvedWedge(
      canvas: canvas,
      center: center,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      startAngle: -math.pi / 1.15 - wedgeAngle - 0.20,
      sweepAngle: wedgeAngle,
      paint: paint,
    );

    // RIGHT wedge
    _drawCurvedWedge(
      canvas: canvas,
      center: center,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
      startAngle: -math.pi / 7.5 + 0.20,
      sweepAngle: wedgeAngle,
      paint: paint,
    );
  }

  void _drawCurvedWedge({
    required Canvas canvas,
    required Offset center,
    required double innerRadius,
    required double outerRadius,
    required double startAngle,
    required double sweepAngle,
    required Paint paint,
  }) {
    final path = Path();

    path.moveTo(
      center.dx + innerRadius * math.cos(startAngle),
      center.dy + innerRadius * math.sin(startAngle),
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      sweepAngle,
      false,
    );

    path.lineTo(
      center.dx + outerRadius * math.cos(startAngle + sweepAngle),
      center.dy + outerRadius * math.sin(startAngle + sweepAngle),
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle + sweepAngle,
      -sweepAngle,
      false,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCenterImage(Canvas canvas, Offset center, double radius) {
    if (centerImage == null) return;

    // Define the size of the center image area
    final imageSize = radius * 1.2; // Adjust size as needed

    // Create a circular clip path
    final clipPath =
        Path()..addOval(
          Rect.fromCenter(
            center: center,
            width: imageSize * 2,
            height: imageSize * 2,
          ),
        );

    canvas.save();
    canvas.clipPath(clipPath);

    // Calculate the destination rectangle for the image
    final destRect = Rect.fromCenter(
      center: center,
      width: imageSize * 2,
      height: imageSize * 2,
    );

    // Calculate source rectangle (entire image)
    final srcRect = Rect.fromLTWH(
      0,
      0,
      centerImage!.width.toDouble(),
      centerImage!.height.toDouble(),
    );

    // Draw the image
    canvas.drawImageRect(
      centerImage!,
      srcRect,
      destRect,
      Paint()..filterQuality = FilterQuality.high,
    );

    canvas.restore();
  }

  void _drawInnerRing(Canvas canvas, Offset center, double radius) {
    final ringPaint =
        Paint()
          ..color = const Color(0xFFFFB74D)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6;

    canvas.drawCircle(center, radius * 0.73, ringPaint);
  }

  void _drawText(Canvas canvas, Offset center, double radius) {
    // Draw "BUM BUM" text
    _drawCurvedText(
      canvas,
      'BUM BUM',
      center,
      radius * 0.67,
      -math.pi * 0.85,
      math.pi * 0.7,
      radius * 0.18,
    );

    // Draw "VADA PAV" text
    final vadaPavStyle = TextStyle(
      color: Colors.white,
      fontSize: radius * 0.16,
      fontWeight: FontWeight.w900,
      letterSpacing: 3,
    );

    final vadaPavPainter = TextPainter(
      text: TextSpan(text: 'VADA PAV', style: vadaPavStyle),
      textDirection: TextDirection.ltr,
    );

    vadaPavPainter.layout();
    vadaPavPainter.paint(
      canvas,
      Offset(center.dx - vadaPavPainter.width / 2, center.dy + radius * 0.225),
    );
  }

  void _drawCurvedText(
    Canvas canvas,
    String text,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    double fontSize,
  ) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
    );

    final anglePerChar = sweepAngle / (text.length - 1);

    for (int i = 0; i < text.length; i++) {
      final angle = startAngle + (i * anglePerChar);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + math.pi / 2);

      final charPainter = TextPainter(
        text: TextSpan(text: text[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );

      charPainter.layout();
      charPainter.paint(canvas, Offset(-charPainter.width / 2, -radius));

      canvas.restore();
    }
  }

  void _drawSinceBadge(Canvas canvas, Offset center, double radius) {
    final badgeWidth = radius * 0.62;
    final badgeHeight = radius * 0.14;
    final badgeTop = center.dy + radius * 0.52;

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, badgeTop),
        width: badgeWidth,
        height: badgeHeight,
      ),
      const Radius.circular(20),
    );

    final badgePaint =
        Paint()
          ..color = const Color(0xFFD84315)
          ..style = PaintingStyle.fill;

    canvas.drawRRect(badgeRect, badgePaint);

    final badgeTextStyle = TextStyle(
      color: Colors.white,
      fontSize: radius * 0.08,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );

    final badgeTextPainter = TextPainter(
      text: TextSpan(text: 'SINCE-2005', style: badgeTextStyle),
      textDirection: TextDirection.ltr,
    );

    badgeTextPainter.layout();
    badgeTextPainter.paint(
      canvas,
      Offset(
        center.dx - badgeTextPainter.width / 2,
        badgeTop - badgeTextPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(VadaPavLogoPainter oldDelegate) {
    return oldDelegate.centerImage != centerImage ||
        oldDelegate.rotationAngle != rotationAngle;
  }
}
