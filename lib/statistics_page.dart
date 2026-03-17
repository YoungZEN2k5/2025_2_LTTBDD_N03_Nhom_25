import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'models.dart';
import 'main.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key, required this.strings, required this.tasks});

  final AppStrings strings;
  final List<TaskItem> tasks;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<TaskItem> monthTasks = widget.tasks
        .where(
          (TaskItem task) =>
              task.deadline.year == _selectedMonth.year &&
              task.deadline.month == _selectedMonth.month,
        )
        .toList();

    final int completed = monthTasks
        .where((TaskItem task) => task.isCompleted)
        .length;
    final int pending = monthTasks.length - completed;
    final int total = monthTasks.length;
    final int completedPercent = total == 0
        ? 0
        : ((completed / total) * 100).round();

    final List<int> weeklyCounts = List<int>.filled(5, 0);
    for (final TaskItem task in monthTasks) {
      final int weekIndex = ((task.deadline.day - 1) ~/ 7).clamp(0, 4);
      weeklyCounts[weekIndex] = weeklyCounts[weekIndex] + 1;
    }
    final int maxWeek = weeklyCounts.reduce(math.max).clamp(1, 9999);

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? <Color>[
                      const Color(0xFF101F1A),
                      const Color(0xFF143128),
                      const Color(0xFF1C3C33),
                    ]
                  : <Color>[
                      const Color(0xFFE6F6EE),
                      const Color(0xFFF7F2E8),
                      const Color(0xFFF0FAF5),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -70,
          right: -30,
          child: _GlowOrb(
            size: 170,
            color: isDark
                ? const Color(0xFF79DAB8).withValues(alpha: 0.24)
                : const Color(0xFF7FDCC0).withValues(alpha: 0.26),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -25,
          child: _GlowOrb(
            size: 150,
            color: isDark
                ? const Color(0xFF9AB4FF).withValues(alpha: 0.16)
                : const Color(0xFFB2C8FF).withValues(alpha: 0.22),
          ),
        ),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? <Color>[
                            const Color(0xFF21473B),
                            const Color(0xFF153028),
                          ]
                        : <Color>[
                            const Color(0xFF1E3F36),
                            const Color(0xFF2D6D5D),
                          ],
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 20,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.strings.get('statistics'),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_selectedMonth.month}/${_selectedMonth.year}  ${widget.strings.get('completed')}: $completed/$total',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month - 1,
                            );
                          });
                        },
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      Expanded(
                        child: Text(
                          '${_selectedMonth.month}/${_selectedMonth.year}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month + 1,
                            );
                          });
                        },
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Task Completion',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 180,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      CustomPaint(
                                        size: const Size(130, 130),
                                        painter: _PiePainter(
                                          completed: completed,
                                          pending: pending,
                                          trackColor: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            '$completedPercent%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          Text(
                                            widget.strings.get('completed'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.72),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _LegendRow(
                                    color: const Color(0xFF2DAA72),
                                    label:
                                        '${widget.strings.get('completed')}: $completed',
                                  ),
                                  const SizedBox(height: 8),
                                  _LegendRow(
                                    color: const Color(0xFFD08D2F),
                                    label:
                                        '${widget.strings.get('pending')}: $pending',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Weekly Tasks (${_selectedMonth.month}/${_selectedMonth.year})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List<Widget>.generate(5, (int i) {
                            final int value = weeklyCounts[i];
                            final double ratio = value / maxWeek;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '$value',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 120 * ratio + 10,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.85),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('W${i + 1}'),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month_rounded),
                  title: Text(
                    '${widget.strings.get('homeTitle')} (${_selectedMonth.month}/${_selectedMonth.year})',
                  ),
                  subtitle: Text('Tasks this month: $total'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: color, blurRadius: 85, spreadRadius: 14),
          ],
        ),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({
    required this.completed,
    required this.pending,
    required this.trackColor,
  });

  final int completed;
  final int pending;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double total = (completed + pending).toDouble();
    final double strokeWidth = 20;
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final Paint completedPaint = Paint()
      ..color = const Color(0xFF2DAA72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final Paint pendingPaint = Paint()
      ..color = const Color(0xFFD08D2F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    if (total <= 0) {
      return;
    }

    const double gap = 0.06;
    final double completedSweep = (completed / total) * math.pi * 2;
    final double pendingSweep = math.pi * 2 - completedSweep;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      (completedSweep - gap).clamp(0.0, math.pi * 2),
      false,
      completedPaint,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2 + completedSweep,
      (pendingSweep - gap).clamp(0.0, math.pi * 2),
      false,
      pendingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.completed != completed || oldDelegate.pending != pending;
  }
}
