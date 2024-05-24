part of '../page.dart';

class _MyInteractionsChart extends StatefulWidget {
  const _MyInteractionsChart(this.controller);
  final MyAnalyticsController controller;

  @override
  State<_MyInteractionsChart> createState() => _MyInteractionsChartState();
}

class _MyInteractionsChartState extends State<_MyInteractionsChart> {
  final List<Color> gradientColors = [Colors.cyan, Colors.blue];
  final showAvg = false.obs;
  double maxBarY = 0;

  List<FlSpot> _calculateData(List<MyInteractionModel> list) {
    List<FlSpot> data = [];
    for (MyInteractionModel m in list) {
      FlSpot? exists =
          data.firstWhereOrNull((e) => e.x == (m.createdAt!.day).toDouble());
      if (exists == null) {
        data.add(FlSpot((m.createdAt!.day).toDouble(), 1));
      } else {
        data[data.indexOf(exists)] = FlSpot(exists.x, (exists.y + 1));
      }
    }
    for (FlSpot s in data) {
      if (maxBarY < s.y) maxBarY = s.y;
    }
    return data;
  }

  List<FlSpot> _calculateAvgData(
      List<FlSpot> data, List<MyInteractionModel> list) {
    List<FlSpot> avgData = [];
    for (FlSpot spot in data) {
      avgData.add(FlSpot(spot.x, list.length / data.length));
    }
    return avgData;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 24.0),
              Expanded(
                child: Obx(
                  () => LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxBarY == 0 ? null : maxBarY * 1.25,
                      lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: MyColorHelper.red1,
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final flSpot = barSpot;
                            return LineTooltipItem(
                              '${flSpot.y}',
                              const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      )),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: maxBarY == 0 ? null : maxBarY / 4,
                              getTitlesWidget: (i, j) => Text('${i.toInt()}')),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1.0,
                              getTitlesWidget: (i, j) => Text('${i.toInt()}')),
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.symmetric(
                              vertical: BorderSide(
                            color: MyColorHelper.black1.withOpacity(0.25),
                          ))),
                      lineBarsData: [
                        LineChartBarData(
                          spots: showAvg.value
                              ? _calculateAvgData(
                                  _calculateData(
                                      widget.controller.interactionAnalytics),
                                  widget.controller.interactionAnalytics)
                              : _calculateData(
                                  widget.controller.interactionAnalytics),
                          isCurved: true,
                          gradient: LinearGradient(colors: gradientColors),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: <Widget>[
                  MyTiles(
                    color: Colors.blue,
                    text: 'Dates',
                    isSquare: true,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () => showAvg.value = !showAvg.value,
              child: const Text(
                'Avg',
                style: TextStyle(
                  fontSize: 12,
                  color: MyColorHelper.red1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
