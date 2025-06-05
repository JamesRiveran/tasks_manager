import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final total = taskProvider.tasks.length;
    final completed = taskProvider.completedTasks.length;
    final pending = taskProvider.pendingTasks.length;
    final percent = total > 0 ? completed / total : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
      ),
      body: total == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No hay estadísticas aún',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega tareas para ver tu progreso',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryCard(context, total, completed, pending),
                  const SizedBox(height: 16),
                  _buildProgressCard(context, percent, completed, total),
                  const SizedBox(height: 16),
                  _buildDistributionCard(context, completed, pending),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int total, int completed, int pending) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget stat(String label, int value, IconData icon, Color iconColor) {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            stat('Total', total, Icons.list, colorScheme.primary),
            stat('Completadas', completed, Icons.task_alt, Colors.green),
            stat('Pendientes', pending, Icons.pending_actions, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double percent, int completed, int total) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(percent * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
                Text(
                  '$completed de $total tareas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(BuildContext context, int completed, int pending) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = completed + pending;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Distribución',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: total == 0
                  ? Center(
                      child: Text(
                        'Sin datos suficientes',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : CustomPaint(
                      painter: PieChartPainter(completed: completed, pending: pending),
                      size: const Size(200, 200),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(context, 'Completadas', Colors.green),
                const SizedBox(width: 32),
                _legendDot(context, 'Pendientes', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(BuildContext context, String label, Color color) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(label, style: textStyle),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final int completed;
  final int pending;

  PieChartPainter({required this.completed, required this.pending});

  @override
  void paint(Canvas canvas, Size size) {
    final total = completed + pending;
    if (total == 0) return;

    final paintCompleted = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final paintPending = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final completedAngle = (completed / total) * 2 * 3.1415926535;
    final pendingAngle = (pending / total) * 2 * 3.1415926535;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      completedAngle,
      true,
      paintCompleted,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2 + completedAngle,
      pendingAngle,
      true,
      paintPending,
    );

    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
