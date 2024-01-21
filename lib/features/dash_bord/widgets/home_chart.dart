import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/responsive.dart';
import '../dash_bord_mv.dart';

class HomePieChart extends StatefulWidget {
  const HomePieChart({
    super.key,
  });

  @override
  State<HomePieChart> createState() => _HomePieChartState();
}

class _HomePieChartState extends State<HomePieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Consumer<DashBordMV>(builder: (context, data, child) {
                return (data.activeFamiliesCount == 0)
                    ? const SizedBox()
                    : SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(-3, 0), end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: controller, curve: Curves.easeIn)),
                        child: PieChart(
                          PieChartData(
                              centerSpaceRadius: Responsive.widthOfScreen(
                                  context: context, width: .1),
                              sections: data.showingSections(),
                              sectionsSpace: 2,
                              startDegreeOffset: 20,
                              pieTouchData: PieTouchData(
                                  enabled: true,
                                  touchCallback: (event, pieTouchResponse) =>
                                      data.touchCallback(
                                          event, pieTouchResponse))),
                        ),
                      );
              }),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(color: Colors.red.shade300, text: 'لم يستلم هذا الشهر'),
              Indicator(color: Colors.teal.shade300, text: 'إستلم هذا الشهر'),
            ],
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({Key? key, required this.color, required this.text})
      : super(key: key);

  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            width: 6,
          ),
          Container(
            color: color,
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
