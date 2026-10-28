import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HeroBanner extends StatefulWidget {
  final VoidCallback onExploreTap;
  final VoidCallback onBookConsultationTap;

  const HeroBanner({
    super.key,
    required this.onExploreTap,
    required this.onBookConsultationTap,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> with TickerProviderStateMixin {
  static const _forest = Color(0xFF08482D);
  static const _ink = Color(0xFF101410);
  static const _paper = Color(0xFFF5F8EF);
  static const _mint = Color(0xFFDAE7C7);

  Timer? _autoScrollTimer;
  late final AnimationController _motionController;
  late final AnimationController _entranceController;
  double _carouselOffset = 0;
  double _dragStart = 0;
  double _dragOrigin = 0;

  final _cards = const [
    (Icons.grid_view_rounded, '7D FLOOR MATS', Color(0xFF6F9F65)),
    (Icons.videocam_rounded, 'DUAL 4K DASH CAM', Color(0xFF8EBB7D)),
    (Icons.airline_seat_recline_normal, 'NAPPA SEAT COVERS', Color(0xFF497B54)),
    (Icons.light_mode_rounded, 'AMBIENT LIGHTING', Color(0xFFB2CC87)),
    (Icons.tire_repair_rounded, 'DIGITAL INFLATOR', Color(0xFF5A9060)),
    (Icons.speaker_rounded, 'PREMIUM AUDIO', Color(0xFF86AD70)),
    (Icons.directions_car_filled_rounded, 'CARBON DETAILING', Color(0xFF3C6D4B)),
    (Icons.settings_rounded, 'TRAVEL ESSENTIALS', Color(0xFF9DBE84)),
    (Icons.shield_rounded, 'PAINT PROTECTION', Color(0xFF548B5E)),
    (Icons.auto_awesome_rounded, 'SIGNATURE FINISH', Color(0xFF789F61)),
  ];

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _motionController.addListener(_handleMotionTick);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 32), (_) {
      if (mounted) {
        setState(() => _carouselOffset = (_carouselOffset + 0.7) % 196);
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _motionController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _handleMotionTick() {
    if (mounted) setState(() {});
  }

  void _beginDrag(DragStartDetails details) {
    _dragStart = details.localPosition.dx;
    _dragOrigin = _carouselOffset;
  }

  void _updateDrag(DragUpdateDetails details) {
    setState(() {
      _carouselOffset = (_dragOrigin - (details.localPosition.dx - _dragStart)) % 196;
      if (_carouselOffset < 0) _carouselOffset += 196;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;

    final hero = Container(
      margin: EdgeInsets.fromLTRB(isCompact ? 10 : 16, 10, isCompact ? 10 : 16, 18),
      padding: EdgeInsets.fromLTRB(isCompact ? 16 : 28, 22, isCompact ? 16 : 28, 20),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _forest.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          _Header(isCompact: isCompact),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _mint,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Trusted by 15,000+ car owners',
              style: TextStyle(
                color: _forest,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isCompact ? 'Upgrade every drive.' : 'Make every drive\nfeel considered.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ink,
              fontSize: isCompact ? 38 : 54,
              height: .98,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.8,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: const Text(
              'Premium car accessories, chosen for the way you drive. '
              'Shop tailored comfort, smarter tech, and signature finishes for your next journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5E5E61),
                fontSize: 15,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: isCompact ? 220 : 270,
            child: GestureDetector(
              onHorizontalDragStart: _beginDrag,
              onHorizontalDragUpdate: _updateDrag,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    for (var index = 0; index < _cards.length; index++)
                      _buildCard(index, constraints.maxWidth, constraints.maxHeight, isCompact),
                    Positioned(
                      left: 6,
                      top: 14,
                      child: Transform.rotate(
                        angle: -.12,
                        child: const Text(
                          '// made to move',
                          style: TextStyle(
                            color: _forest,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 8,
                      child: Transform.rotate(
                        angle: .12,
                        child: const Text(
                          'built for the long way →',
                          style: TextStyle(
                            color: _forest,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              OutlinedButton(
                onPressed: widget.onExploreTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _forest,
                  side: const BorderSide(color: _forest, width: 1.4),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Browse the collection'),
              ),
              ElevatedButton(
                onPressed: widget.onBookConsultationTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text('Make a better drive'),
              ),
            ],
          ),
        ],
      ),
    );

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, .06),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: hero,
      ),
    );
  }

  Widget _buildCard(int index, double availableWidth, double availableHeight, bool compact) {
    final pitch = compact ? 112.0 : 142.0;
    final center = availableWidth / 2;
    final baseX = (index - (_cards.length - 1) / 2) * pitch - _carouselOffset;
    final wrappedX = ((baseX + availableWidth * 2) % (availableWidth * 2)) - availableWidth;
    final distance = (wrappedX / (availableWidth / 2)).abs().clamp(0.0, 1.35).toDouble();
    final width = (compact ? 94.0 : 116.0) + 22 * math.min(distance, 1);
    final height = (compact ? 168.0 : 214.0) + 42 * math.min(distance, 1);
    final y = (availableHeight - height) / 2 + 28 * math.min(distance, 1);
    final x = center + wrappedX - width / 2;
    final card = _cards[index];
    final floatOffset = math.sin((_motionController.value * math.pi * 2) + index * .8) * 4;
    final floatRotation = math.sin((_motionController.value * math.pi * 2) + index) * .012;

    return Positioned(
      left: x,
      top: y + floatOffset,
      width: width,
      height: height,
      child: Transform.rotate(
        angle: wrappedX / (availableWidth * 1.8) + floatRotation,
        child: Container(
          decoration: BoxDecoration(
            color: card.$3,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: .7), width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: -24,
                top: 12,
                child: Icon(card.$1, size: width * 1.05, color: Colors.white.withValues(alpha: .16)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(card.$1, size: compact ? 27 : 34, color: Colors.white),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      card.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .72),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, size: 14, color: _forest),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isCompact;

  const _Header({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.eco_rounded, color: Color(0xFF08482D), size: 27),
        const SizedBox(width: 7),
        const Text(
          'CARVORA',
          style: TextStyle(
            color: Color(0xFF08482D),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        if (!isCompact)
          const Row(
            children: [
              Text('Showcase', style: _navStyle),
              SizedBox(width: 22),
              Text('Collections', style: _navStyle),
              SizedBox(width: 22),
              Text('Our craft', style: _navStyle),
            ],
          ),
        const SizedBox(width: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF08482D),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

const _navStyle = TextStyle(
  color: Color(0xFF08482D),
  fontSize: 13,
  fontWeight: FontWeight.w600,
);
