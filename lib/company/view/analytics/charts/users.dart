part of '../page.dart';

class _StatusesModel {
  _StatusesModel(this.title, this.color);
  final String title;
  final Color color;
}

class _MyUsersChart extends StatefulWidget {
  const _MyUsersChart(this.controller);
  final MyAnalyticsController controller;

  @override
  State<StatefulWidget> createState() => _MyUsersChartState();
}

class _MyUsersChartState extends State<_MyUsersChart> {
  int maxBarValue = 0;
  late List<_StatusesModel> _data;
  final RxInt _touchedIndex = RxInt(-1);

  @override
  void initState() {
    _data = [
      _StatusesModel('Admins', MyColorHelper.adminUsers),
      _StatusesModel('Managers', MyColorHelper.managerUsers),
      _StatusesModel('PR Members', MyColorHelper.prMemberUsers),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 24.0),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Obx(
                () => BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: MyColorHelper.red1,
                        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                        tooltipMargin: -10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${_data[group.x].title}\n',
                            const TextStyle(
                              color: MyColorHelper.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: (rod.toY - 1).toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: MyColorHelper.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          _touchedIndex.value = -1;
                          return;
                        }
                        _touchedIndex.value =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (i, j) => Text(
                                  '${i.toInt()}',
                                )),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: List.generate(_data.length, (i) {
                      int value = widget.controller.usersAnalytics
                          .where((e) => i == 0
                              ? (e.userType == MyUserType.admin)
                              : i == 1
                                  ? (e.userType == MyUserType.user)
                                  : i == 2
                                      ? e.userType == MyUserType.prMember
                                      : false)
                          .toList()
                          .length;
                      if (value > maxBarValue) maxBarValue = value;
                      return BarChartGroupData(
                        x: widget.controller.usersAnalytics.isEmpty ? i : i,
                        barRods: [
                          BarChartRodData(
                            toY: (i == _touchedIndex.value ? value + 1 : value)
                                .toDouble(),
                            color: i == _touchedIndex.value
                                ? MyColorHelper.black1
                                : _data[i].color,
                            width: constraints.maxWidth * 0.08,
                            borderSide: i == _touchedIndex.value
                                ? const BorderSide(color: MyColorHelper.red1)
                                : const BorderSide(
                                    color: Colors.white, width: 0),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: ((maxBarValue * 1.15).toInt().toDouble()),
                              color: MyColorHelper.red1.withOpacity(0.10),
                            ),
                          ),
                        ],
                      );
                    }),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: <Widget>[
              MyTiles(
                color: MyColorHelper.adminUsers,
                text: 'Admins',
                isSquare: true,
              ),
              MyTiles(
                color: MyColorHelper.managerUsers,
                text: 'Managers',
                isSquare: true,
              ),
              MyTiles(
                color: MyColorHelper.prMemberUsers,
                text: 'PR Members',
                isSquare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
