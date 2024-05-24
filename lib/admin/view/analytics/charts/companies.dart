part of '../page.dart';

class _MyCompaniesChart extends StatefulWidget {
  const _MyCompaniesChart(this.controller, {required this.size});
  final MyAnalyticsController controller;
  final double size;

  @override
  State<_MyCompaniesChart> createState() => _MyCompaniesChartState();
}

class _MyCompaniesChartState extends State<_MyCompaniesChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () => PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 5,
                    centerSpaceRadius: 25,
                    sections: List.generate(4, (i) {
                      switch (i) {
                        case 0:
                          return _section(i, null, null);
                        case 1:
                          return _section(i, true, true);
                        case 2:
                          return _section(i, true, false);
                        case 3:
                          return _section(i, false, false);
                        default:
                          throw Error();
                      }
                    }),
                  ),
                ),
              ),
            ),
          ),
          const Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: <Widget>[
              MyTiles(
                color: MyColorHelper.pendingCompanies,
                text: 'Pending',
                isSquare: true,
              ),
              MyTiles(
                color: MyColorHelper.activeCompanies,
                text: 'Active',
                isSquare: true,
              ),
              MyTiles(
                color: MyColorHelper.inactiveCompanies,
                text: 'Inactive',
                isSquare: true,
              ),
              MyTiles(
                color: MyColorHelper.rejectedCompanies,
                text: 'Rejected',
                isSquare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(int i, bool? register, bool? status) {
    int value = widget.controller.companiesAnalytics
        .where((e) => (e.register == register && e.status == status))
        .toList()
        .length;
    return PieChartSectionData(
      color: i == 0
          ? Colors.blue
          : i == 1
              ? Colors.green
              : i == 2
                  ? Colors.orange
                  : Colors.red,
      value: value == 0 ? 1 : value.toDouble(),
      title: '$value',
      radius: i == touchedIndex ? widget.size : widget.size - 10,
      titleStyle: TextStyle(
        fontSize: i == touchedIndex ? 24.0 : 16.0,
        fontWeight: FontWeight.bold,
        color: MyColorHelper.white,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),
    );
  }
}
