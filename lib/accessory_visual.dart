import 'package:flutter/material.dart';
import '../theme/carvora_theme.dart';

class AccessoryVisual extends StatelessWidget {
  final String iconType;
  final double height;
  final bool showAmbientGlow;

  const AccessoryVisual({
    super.key,
    required this.iconType,
    this.height = 140,
    this.showAmbientGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF161B26),
            Color(0xFF0D1017),
          ],
        ),
        border: Border.all(
          color: CarvoraColors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient back glow
          if (showAmbientGlow)
            Positioned(
              child: Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getGlowColor(iconType).withValues(alpha: 0.25),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

          // Custom visual painter
          CustomPaint(
            size: Size(double.infinity, height),
            painter: _AccessoryArtPainter(iconType: iconType),
          ),
        ],
      ),
    );
  }

  Color _getGlowColor(String type) {
    switch (type) {
      case 'mat':
        return CarvoraColors.gold;
      case 'camera':
        return CarvoraColors.cyanAccent;
      case 'seat':
        return Colors.amber;
      case 'inflator':
        return Colors.blueAccent;
      case 'ambient':
        return Colors.purpleAccent;
      case 'perfume':
        return CarvoraColors.gold;
      case 'vacuum':
        return Colors.tealAccent;
      case 'cover':
        return Colors.lightBlueAccent;
      case 'mount':
        return Colors.indigoAccent;
      case 'pillow':
        return Colors.orangeAccent;
      default:
        return CarvoraColors.gold;
    }
  }
}

class _AccessoryArtPainter extends CustomPainter {
  final String iconType;

  _AccessoryArtPainter({required this.iconType});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (iconType) {
      case 'mat':
        _paintFloorMat(canvas, cx, cy);
        break;
      case 'camera':
        _paintDashCam(canvas, cx, cy);
        break;
      case 'seat':
        _paintSeatCover(canvas, cx, cy);
        break;
      case 'inflator':
        _paintTyreInflator(canvas, cx, cy);
        break;
      case 'ambient':
        _paintAmbientLight(canvas, cx, cy);
        break;
      case 'perfume':
        _paintSolarPerfume(canvas, cx, cy);
        break;
      case 'vacuum':
        _paintCarVacuum(canvas, cx, cy);
        break;
      case 'cover':
        _paintBodyCover(canvas, cx, cy);
        break;
      case 'mount':
        _paintPhoneMount(canvas, cx, cy);
        break;
      case 'pillow':
        _paintNeckPillow(canvas, cx, cy);
        break;
      default:
        _paintFloorMat(canvas, cx, cy);
    }
  }

  // 1. 7D Diamond Floor Mat
  void _paintFloorMat(Canvas canvas, double cx, double cy) {
    final matRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 100, height: 74),
      const Radius.circular(10),
    );

    // Outer mat
    canvas.drawRRect(matRect, Paint()..color = const Color(0xFF1B2232));
    canvas.drawRRect(
      matRect,
      Paint()
        ..color = CarvoraColors.gold.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Diamond stitch grid
    final stitchPaint = Paint()
      ..color = CarvoraColors.gold.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(cx - 40 + (i * 14.0), cy - 28),
        Offset(cx - 10 + (i * 14.0), cy + 28),
        stitchPaint,
      );
      canvas.drawLine(
        Offset(cx + 40 - (i * 14.0), cy - 28),
        Offset(cx + 10 - (i * 14.0), cy + 28),
        stitchPaint,
      );
    }

    // Heavy-duty rubber heel pad in center
    final heelPad = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 8), width: 44, height: 26),
      const Radius.circular(6),
    );
    canvas.drawRRect(heelPad, Paint()..color = const Color(0xFF10141D));
    canvas.drawRRect(
      heelPad,
      Paint()
        ..color = CarvoraColors.borderHighlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Tread lines on heel pad
    for (int j = -2; j <= 2; j++) {
      canvas.drawLine(
        Offset(cx - 16, cy + 8 + (j * 4.0)),
        Offset(cx + 16, cy + 8 + (j * 4.0)),
        Paint()
          ..color = CarvoraColors.gold
          ..strokeWidth = 1.5,
      );
    }
  }

  // 2. Dual 4K Dash Cam
  void _paintDashCam(Canvas canvas, double cx, double cy) {
    // Main camera body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 84, height: 48),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, Paint()..color = const Color(0xFF181E2B));
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = CarvoraColors.cyanAccent.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Big front lens
    canvas.drawCircle(Offset(cx - 16, cy), 16, Paint()..color = const Color(0xFF0F1420));
    canvas.drawCircle(
      Offset(cx - 16, cy),
      16,
      Paint()
        ..color = CarvoraColors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(cx - 16, cy), 10, Paint()..color = const Color(0xFF2C4368));
    canvas.drawCircle(Offset(cx - 16, cy), 5, Paint()..color = Colors.white70);

    // Screen preview on right side
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 20, cy), width: 28, height: 32),
      const Radius.circular(4),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFF080C14));
    canvas.drawRRect(
      screenRect,
      Paint()
        ..color = Colors.blueGrey.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Recording red LED
    canvas.drawCircle(Offset(cx + 32, cy - 14), 2.5, Paint()..color = Colors.redAccent);

    // Suction windscreen mount arm
    canvas.drawLine(
      Offset(cx, cy - 24),
      Offset(cx, cy - 36),
      Paint()
        ..color = const Color(0xFF3B4861)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 38), width: 26, height: 12),
      3.14,
      3.14,
      true,
      Paint()..color = const Color(0xFF2A3447),
    );
  }

  // 3. Ergonomic Nappa Seat Cover
  void _paintSeatCover(Canvas canvas, double cx, double cy) {
    // Headrest
    final headrest = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 34), width: 34, height: 18),
      const Radius.circular(6),
    );
    canvas.drawRRect(headrest, Paint()..color = const Color(0xFF222B3D));
    canvas.drawRRect(
      headrest,
      Paint()
        ..color = CarvoraColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Seat backrest with side bolsters
    final backPath = Path()
      ..moveTo(cx - 24, cy - 22)
      ..lineTo(cx + 24, cy - 22)
      ..lineTo(cx + 32, cy + 12)
      ..lineTo(cx - 32, cy + 12)
      ..close();
    canvas.drawPath(backPath, Paint()..color = const Color(0xFF181F2E));
    canvas.drawPath(
      backPath,
      Paint()
        ..color = CarvoraColors.gold.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Vertical sport dual racing stripes
    final stripePaint = Paint()
      ..color = CarvoraColors.gold
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(cx - 4, cy - 20), Offset(cx - 4, cy + 10), stripePaint);
    canvas.drawLine(Offset(cx + 4, cy - 20), Offset(cx + 4, cy + 10), stripePaint);

    // Seat base cushion
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 24), width: 68, height: 22),
      const Radius.circular(6),
    );
    canvas.drawRRect(baseRect, Paint()..color = const Color(0xFF1D2638));
    canvas.drawRRect(
      baseRect,
      Paint()
        ..color = CarvoraColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  // 4. Digital Tyre Inflator
  void _paintTyreInflator(Canvas canvas, double cx, double cy) {
    // Cylinder body
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 44, height: 72),
      const Radius.circular(10),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFF182030));
    canvas.drawRRect(
      body,
      Paint()
        ..color = Colors.blueAccent.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Digital pressure circular display
    canvas.drawCircle(Offset(cx, cy - 10), 14, Paint()..color = const Color(0xFF090D14));
    canvas.drawCircle(
      Offset(cx, cy - 10),
      14,
      Paint()
        ..color = CarvoraColors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // 33 PSI text representation bar
    canvas.drawLine(
      Offset(cx - 6, cy - 10),
      Offset(cx + 6, cy - 10),
      Paint()
        ..color = CarvoraColors.cyanAccent
        ..strokeWidth = 2,
    );

    // Controls (+ / - buttons)
    canvas.drawCircle(Offset(cx - 8, cy + 16), 3.5, Paint()..color = Colors.white54);
    canvas.drawCircle(Offset(cx + 8, cy + 16), 3.5, Paint()..color = Colors.white54);
    canvas.drawCircle(Offset(cx, cy + 16), 4, Paint()..color = CarvoraColors.gold);

    // Air hose loop on top
    final hosePath = Path()
      ..moveTo(cx - 10, cy - 36)
      ..quadraticBezierTo(cx - 24, cy - 50, cx - 18, cy - 20);
    canvas.drawPath(
      hosePath,
      Paint()
        ..color = const Color(0xFF4C5D7D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  // 5. RGB Symphony Ambient Light
  void _paintAmbientLight(Canvas canvas, double cx, double cy) {
    // Dual curved dynamic neon light ribbons with multi-color gradient
    final p1 = Path()
      ..moveTo(cx - 48, cy + 16)
      ..quadraticBezierTo(cx - 16, cy - 28, cx + 18, cy + 8)
      ..quadraticBezierTo(cx + 36, cy + 24, cx + 52, cy - 14);

    final grad = const LinearGradient(
      colors: [
        Colors.redAccent,
        Colors.amberAccent,
        Colors.greenAccent,
        Colors.cyanAccent,
        Colors.purpleAccent,
      ],
    ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: 100, height: 60));

    // Outer glow aura
    canvas.drawPath(
      p1,
      Paint()
        ..shader = grad
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Core bright optical tube
    canvas.drawPath(
      p1,
      Paint()
        ..shader = grad
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Center white neon spark line
    canvas.drawPath(
      p1,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
  }

  // 6. Solar Rotating Aromatherapy Perfume
  void _paintSolarPerfume(Canvas canvas, double cx, double cy) {
    // Base platform
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 18), width: 64, height: 16),
      const Radius.circular(6),
    );
    canvas.drawRRect(baseRect, Paint()..color = const Color(0xFF1B2332));
    canvas.drawRRect(
      baseRect,
      Paint()
        ..color = CarvoraColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Solar photovoltaic cell disc in center
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 14), width: 42, height: 8),
      Paint()..color = const Color(0xFF0F1522),
    );

    // Two interlocking orbital rotating rings
    final ringPaint1 = Paint()
      ..color = CarvoraColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final ringPaint2 = Paint()
      ..color = CarvoraColors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 44, height: 28),
      ringPaint1,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 28, height: 44),
      ringPaint2,
    );

    // Center aroma crystal bead
    canvas.drawCircle(Offset(cx, cy - 8), 6, Paint()..color = CarvoraColors.gold);
    canvas.drawCircle(Offset(cx, cy - 8), 3, Paint()..color = Colors.white);
  }

  // 7. High-Power Cordless Car Vacuum
  void _paintCarVacuum(Canvas canvas, double cx, double cy) {
    // Ergonomic handheld body
    final body = Path()
      ..moveTo(cx - 36, cy - 8)
      ..lineTo(cx + 10, cy - 14)
      ..lineTo(cx + 40, cy - 4) // Nozzle
      ..lineTo(cx + 40, cy + 6)
      ..lineTo(cx + 10, cy + 12)
      ..lineTo(cx - 24, cy + 18)
      ..close();

    canvas.drawPath(body, Paint()..color = const Color(0xFF192233));
    canvas.drawPath(
      body,
      Paint()
        ..color = Colors.tealAccent.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Handle loop
    final handle = Path()
      ..moveTo(cx - 32, cy - 6)
      ..quadraticBezierTo(cx - 46, cy + 4, cx - 28, cy + 22);
    canvas.drawPath(
      handle,
      Paint()
        ..color = const Color(0xFF33425B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Clear dust cup divider
    canvas.drawLine(
      Offset(cx + 10, cy - 14),
      Offset(cx + 10, cy + 12),
      Paint()
        ..color = Colors.tealAccent
        ..strokeWidth = 2,
    );

    // Power trigger switch
    canvas.drawCircle(Offset(cx - 16, cy + 2), 3, Paint()..color = CarvoraColors.gold);
  }

  // 8. 5-Layer All-Weather Body Cover
  void _paintBodyCover(Canvas canvas, double cx, double cy) {
    // Stylized covered SUV silhouette
    final carCover = Path()
      ..moveTo(cx - 44, cy + 16)
      ..lineTo(cx - 42, cy + 4)
      ..quadraticBezierTo(cx - 32, cy - 4, cx - 18, cy - 18) // Windscreen
      ..lineTo(cx + 16, cy - 18) // Roof
      ..quadraticBezierTo(cx + 34, cy - 6, cx + 44, cy + 4) // Rear
      ..lineTo(cx + 46, cy + 16)
      ..quadraticBezierTo(cx, cy + 18, cx - 44, cy + 16)
      ..close();

    canvas.drawPath(carCover, Paint()..color = const Color(0xFF1E283A));
    canvas.drawPath(
      carCover,
      Paint()
        ..color = Colors.lightBlueAccent.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Bright fluorescent orange/silver safety reflective stripe
    final stripe = Path()
      ..moveTo(cx - 38, cy + 8)
      ..quadraticBezierTo(cx, cy + 6, cx + 38, cy + 8);
    canvas.drawPath(
      stripe,
      Paint()
        ..color = Colors.orangeAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Wheel pocket arches
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - 24, cy + 18), width: 18, height: 18),
      3.14,
      3.14,
      false,
      Paint()
        ..color = const Color(0xFF101520)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + 24, cy + 18), width: 18, height: 18),
      3.14,
      3.14,
      false,
      Paint()
        ..color = const Color(0xFF101520)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  // 9. Auto-Clamping Wireless Phone Mount
  void _paintPhoneMount(Canvas canvas, double cx, double cy) {
    // Mounting base plate
    final base = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 44, height: 64),
      const Radius.circular(8),
    );
    canvas.drawRRect(base, Paint()..color = const Color(0xFF151C28));
    canvas.drawRRect(
      base,
      Paint()
        ..color = Colors.indigoAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Qi Wireless charging circular coil
    canvas.drawCircle(Offset(cx, cy), 14, Paint()..color = const Color(0xFF0B1019));
    canvas.drawCircle(
      Offset(cx, cy),
      14,
      Paint()
        ..color = CarvoraColors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Qi icon lightning bolt
    final bolt = Path()
      ..moveTo(cx + 2, cy - 8)
      ..lineTo(cx - 4, cy + 1)
      ..lineTo(cx, cy + 1)
      ..lineTo(cx - 2, cy + 8)
      ..lineTo(cx + 4, cy - 1)
      ..lineTo(cx, cy - 1)
      ..close();
    canvas.drawPath(bolt, Paint()..color = CarvoraColors.gold);

    // Motorized side clamping arms
    final armPaint = Paint()
      ..color = const Color(0xFF334460)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 22, cy - 8), Offset(cx - 28, cy - 8), armPaint);
    canvas.drawLine(Offset(cx - 28, cy - 8), Offset(cx - 28, cy + 8), armPaint);

    canvas.drawLine(Offset(cx + 22, cy - 8), Offset(cx + 28, cy - 8), armPaint);
    canvas.drawLine(Offset(cx + 28, cy - 8), Offset(cx + 28, cy + 8), armPaint);

    // Bottom support feet
    canvas.drawLine(Offset(cx - 10, cy + 32), Offset(cx - 10, cy + 38), armPaint);
    canvas.drawLine(Offset(cx + 10, cy + 32), Offset(cx + 10, cy + 38), armPaint);
  }

  // 10. Memory Foam Ergonomic Neck Pillow
  void _paintNeckPillow(Canvas canvas, double cx, double cy) {
    // Contoured butterfly ergonomic cushion
    final pillowPath = Path()
      ..moveTo(cx - 36, cy - 14)
      ..quadraticBezierTo(cx, cy - 20, cx + 36, cy - 14)
      ..quadraticBezierTo(cx + 42, cy, cx + 36, cy + 14)
      ..quadraticBezierTo(cx, cy + 8, cx - 36, cy + 14)
      ..quadraticBezierTo(cx - 42, cy, cx - 36, cy - 14)
      ..close();

    canvas.drawPath(pillowPath, Paint()..color = const Color(0xFF1F293C));
    canvas.drawPath(
      pillowPath,
      Paint()
        ..color = Colors.orangeAccent.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Center contour indentation for cervical neck support
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 26, height: 12),
      Paint()..color = const Color(0xFF141A28),
    );

    // Elastic strap behind
    canvas.drawLine(
      Offset(cx - 40, cy),
      Offset(cx + 40, cy),
      Paint()
        ..color = const Color(0xFF3D4F70)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
