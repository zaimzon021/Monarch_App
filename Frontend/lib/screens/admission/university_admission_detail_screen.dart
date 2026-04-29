import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../explore/university_detail_screen.dart';

Route<void> admissionDetailRoute(Map<String, dynamic> university) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) =>
        UniversityAdmissionDetailScreen(university: university),
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween(begin: const Offset(0, 1), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

class UniversityAdmissionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> university;
  const UniversityAdmissionDetailScreen({super.key, required this.university});
  @override
  State<UniversityAdmissionDetailScreen> createState() => _UDS();
}

class _UDS extends State<UniversityAdmissionDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _gc, _bc;
  late final Animation<double> _ga, _b1, _b2, _b3;

  @override
  void initState() {
    super.initState();
    _gc = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _ga = CurvedAnimation(parent: _gc, curve: Curves.easeOutCubic);
    _bc = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _b1 = CurvedAnimation(parent: _bc, curve: const Interval(0.00, 0.60, curve: Curves.easeOutCubic));
    _b2 = CurvedAnimation(parent: _bc, curve: const Interval(0.18, 0.76, curve: Curves.easeOutCubic));
    _b3 = CurvedAnimation(parent: _bc, curve: const Interval(0.36, 0.92, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 220), () { if (mounted) _gc.forward(); });
    Future.delayed(const Duration(milliseconds: 820), () { if (mounted) _bc.forward(); });
  }

  @override
  void dispose() { _gc.dispose(); _bc.dispose(); super.dispose(); }

  static Color _mc(int p) {
    if (p >= 80) return const Color(0xFF16A34A);
    if (p >= 70) return const Color(0xFF22C55E);
    if (p >= 50) return const Color(0xFFEAB308);
    return const Color(0xFFEF4444);
  }

  static Color _cc(String c) {
    switch (c.toLowerCase()) {
      case 'safety': return const Color(0xFF16A34A);
      case 'target': return const Color(0xFF2563EB);
      case 'reach':  return const Color(0xFFDC2626);
      default:       return const Color(0xFF6B7280);
    }
  }

  static int _norm(dynamic raw, int max) =>
      (((raw as num?)?.toDouble() ?? 0) / max * 100).round().clamp(0, 100);

  @override
  Widget build(BuildContext context) {
    final u = widget.university;
    final name     = u['name']        as String? ?? 'Unknown University';
    final location = u['location']    as String? ?? '';
    final imageUrl = u['imageUrl']    as String? ?? '';
    final int pct  = ((u['matchPercentage'] ?? 0) as num).toInt();
    final chance   = u['admissionChance'] as String? ?? 'Target';
    final rec      = u['recommendation']  as String? ?? '';
    final bd       = (u['breakdown'] as Map<String, dynamic>?) ?? {};
    final ins      = (u['insights']  as Map<String, dynamic>?) ?? {};
    final lr       = (u['languageRequirements'] as Map<String, dynamic>?) ?? {};
    final double gpa = ((u['requiredGpa'] ?? 0) as num).toDouble();

    final int ap = _norm(bd['academicMatch'],  40);
    final int lp = _norm(bd['languageMatch'],  30);
    final int fp = _norm(bd['financialMatch'], 20);
    final mc = _mc(pct);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true,
          backgroundColor: const Color(0xFF1A202C),
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A202C)))
                : Container(decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFFF9E81), Color(0xFFFF7A66)]))),
          ),
        ),

        SliverToBoxAdapter(child: Column(children: [
          const SizedBox(height: 20),

          // ── gauge card ──────────────────────────────────────────────────────
          _Crd(child: Column(children: [
            const Text('Your Chances ✨',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E))),
            const SizedBox(height: 2),
            Text('Based on your profile',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 4),

            // ── speedometer: painter + text in Stack ────────────────────────
            AnimatedBuilder(
              animation: _ga,
              builder: (_, __) {
                final cur = (pct * _ga.value).round();
                return SizedBox(
                  height: 175,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _Gauge(progress: _ga.value, percent: pct),
                        ),
                      ),
                      // % text inside dome — bottom:40 keeps it clear of arc strokes
                      Positioned(
                        left: 0, right: 0,
                        bottom: 40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$cur%',
                                style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: mc,
                                    height: 1.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── green rainbow arch banner (fills gap below pivot) ────────
            _ArchBanner(chance: chance),
            const SizedBox(height: 12),
            const SizedBox(height: 14),

            Text(name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E))),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(location, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ]),
          ])),

          // ── breakdown card ──────────────────────────────────────────────────
          _Crd(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Match Breakdown',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E))),
            const SizedBox(height: 20),
            _Bar(anim: _b1, label: 'GPA Match',    pct: ap, color: const Color(0xFFFF7A66)),
            const SizedBox(height: 14),
            _Bar(anim: _b2, label: 'Language',      pct: lp, color: const Color(0xFF38B2AC)),
            const SizedBox(height: 14),
            _Bar(anim: _b3, label: 'Financial Aid', pct: fp, color: const Color(0xFF9F7AEA)),
          ])),



          // ── CTA ─────────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UniversityDetailScreen(university: widget.university),
                ),
              ),
              child: Container(
                width: double.infinity, height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29),
                  gradient: const LinearGradient(colors: [Color(0xFFFF9E81), Color(0xFFFF7A66)]),
                  boxShadow: [BoxShadow(
                      color: const Color(0xFFFF7A66).withValues(alpha: 0.40),
                      blurRadius: 16, offset: const Offset(0, 7))],
                ),
                child: const Center(child: Text('See More',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ])),
      ]),
    );
  }
}

// ── Card ─────────────────────────────────────────────────────────────────────
class _Crd extends StatelessWidget {
  final Widget child;
  const _Crd({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: child,
      );
}

// ── Premium bar (label inside fill, % on right) ───────────────────────────────
class _Bar extends StatelessWidget {
  final Animation<double> anim;
  final String label;
  final int pct;
  final Color color;
  const _Bar({required this.anim, required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: anim,
        builder: (_, __) {
          final cur = (pct * anim.value).round();
          final frac = (anim.value * pct / 100).clamp(0.0, 1.0);
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(children: [
              // track
              Container(height: 48, width: double.infinity,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14))),
              // fill
              FractionallySizedBox(
                widthFactor: frac,
                child: Container(height: 48,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14))),
              ),
              // labels overlay
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: frac > 0.42 ? Colors.white : color)),
                    Text('$cur%',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,
                            color: frac > 0.88 ? Colors.white : color)),
                  ]),
                ),
              ),
            ]),
          );
        },
      );
}

// ── Chip ─────────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
            Text(value, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
          ]),
        ]),
      );
}

// ── Status row ────────────────────────────────────────────────────────────────
class _SR extends StatelessWidget {
  final String label, status;
  const _SR({required this.label, required this.status});
  static String _t(String s) {
    switch (s.toLowerCase()) {
      case 'meets':   return '✅  Meets requirement';
      case 'exceeds': return '🌟  Exceeds requirement';
      case 'below':   return '⚠️  Below requirement';
      default:        return s;
    }
  }
  static Color _c(String s) {
    switch (s.toLowerCase()) {
      case 'meets':   return const Color(0xFF16A34A);
      case 'exceeds': return const Color(0xFF2563EB);
      case 'below':   return const Color(0xFFDC2626);
      default:        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) => Row(children: [
        Text('$label: ', style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568), fontWeight: FontWeight.w500)),
        Text(_t(status), style: TextStyle(fontSize: 13, color: _c(status), fontWeight: FontWeight.w600)),
      ]);
}

// ── Speedometer painter ───────────────────────────────────────────────────────
//
// Flutter canvas: y-axis points DOWN.
// startAngle = π  → left  (9 o'clock)
// sweepAngle = +π → clockwise on screen = goes UP through 12 o'clock → right
//                   This draws the TOP semicircle (upward dome). ✓
//
// Needle: angle = π + π*(pct/100)*progress
//   0%  → π   (points left)
//   50% → 3π/2 (points straight UP, sin=-1 → y decreases → goes above pivot)
//   100%→ 2π=0 (points right)
// ─────────────────────────────────────────────────────────────────────────────
class _Gauge extends CustomPainter {
  final double progress;
  final int percent;
  _Gauge({required this.progress, required this.percent});

  static const _clrs = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF4ADE80),
    Color(0xFF16A34A),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Pivot slightly above bottom edge so the pivot dot is fully visible
    final cy = size.height - 8.0;
    // Radius: fit within width, but also ≤ (cy) so dome fits vertically
    final r = math.min(cx * 0.90, cy * 0.92);

    const start = math.pi;   // left
    const sweep = math.pi;   // +π → upward dome ✓

    // background arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      start, sweep, false,
      Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round,
    );

    // coloured gradient (80 micro-segments)
    const n = 80;
    final sp = sweep / n;
    final active = (n * (percent / 100.0) * progress).round();
    for (int i = 0; i < active; i++) {
      final t = i / n;
      final ct = t * (_clrs.length - 1);
      final ci = ct.floor().clamp(0, _clrs.length - 2);
      final col = Color.lerp(_clrs[ci], _clrs[ci + 1], ct - ci)!;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start + sp * i, sp * 0.88, false,
        Paint()..color = col..style = PaintingStyle.stroke..strokeWidth = 20..strokeCap = StrokeCap.round,
      );
    }

    // "High" label near the upper-right of the arc (at ~80% of sweep)
    final hlAngle = math.pi + math.pi * 0.80; // ≈ 1.8π → upper right
    final hlx = cx + (r + 18) * math.cos(hlAngle);
    final hly = cy + (r + 18) * math.sin(hlAngle);
    final tp = TextPainter(
      text: const TextSpan(
        text: 'High',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(hlx - tp.width / 2, hly - tp.height / 2));

    // needle
    final na = math.pi + math.pi * (percent / 100.0) * progress;
    final nl = r * 0.70;
    final nx = cx + nl * math.cos(na);
    final ny = cy + nl * math.sin(na);

    // shadow
    canvas.drawLine(Offset(cx + 1, cy + 1), Offset(nx + 1, ny + 1),
        Paint()..color = Colors.black.withValues(alpha: 0.12)..strokeWidth = 4..strokeCap = StrokeCap.round);
    // needle line
    canvas.drawLine(Offset(cx, cy), Offset(nx, ny),
        Paint()..color = const Color(0xFF1A202C)..strokeWidth = 3.5..strokeCap = StrokeCap.round);

    // pivot — light green
    canvas.drawCircle(Offset(cx, cy), 11, Paint()..color = const Color(0xFF86EFAC));
    canvas.drawCircle(Offset(cx, cy), 7,  Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx, cy), 4,  Paint()..color = const Color(0xFF22C55E));
  }

  @override
  bool shouldRepaint(_Gauge o) => o.progress != progress || o.percent != percent;
}

// ── Rainbow arch banner (green, rainbow-top, white text) ─────────────────────
// Sits directly below the speedometer pivot, filling the visual gap.
// The top edge curves UPWARD (arch/rainbow shape) matching the dome's curvature.
class _ArchBanner extends StatelessWidget {
  final String chance;
  const _ArchBanner({required this.chance});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ArchClipper(),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Align(
          alignment: const Alignment(0, 0.6),
          child: Text(
            chance,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// The arch at the top curves upward (like the bottom of the speedometer dome)
class _ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Left edge starts midway down
    path.moveTo(0, size.height * 0.55);
    // Arch curves up to the top centre then back down to the right edge
    path.quadraticBezierTo(
      size.width / 2, -size.height * 0.15, // peak: slightly ABOVE the widget top
      size.width, size.height * 0.55,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _ArchClipper o) => false;
}
