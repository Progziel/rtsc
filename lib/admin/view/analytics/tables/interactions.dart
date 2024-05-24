part of '../page.dart';

class _MyInteractionsTable extends StatelessWidget {
  const _MyInteractionsTable(this.controller);
  final MyAnalyticsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        TextButton(
            onPressed: () => DefaultTabController.of(context).animateTo(0),
            child: const Text(
              '< Back to analytics',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
            child: ColoredBox(
              color: MyColorHelper.white.withOpacity(0.75),
              child: Obx(
                () => SfDataGrid(
                  highlightRowOnHover: true,
                  source: _MyInteractionsDataSource(
                    controller.interactionAnalytics,
                  ),
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    _column('type', 'Type', 150),
                    _column('data', 'Data'),
                  ],
                  // onCellTap: (DataGridCellTapDetails details) {
                  //   if (details.column.columnName == 'detail' &&
                  //       details.rowColumnIndex.rowIndex != 0) {
                  //     // showDialog(
                  //     //     context: context,
                  //     //     builder: (dContext) => const MyActivityAddition1());
                  //     // _tasksDialog(
                  //     //     context, details.rowColumnIndex.rowIndex - 1);
                  //   }
                  // },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  GridColumn _column(String name, String value, [double? width]) => GridColumn(
      columnName: name,
      width: width ?? double.nan,
      label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: MyColorHelper.red1.withOpacity(0.80),
          alignment: Alignment.center,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: MyColorHelper.white),
          )));
}

class _MyInteractionsDataSource extends DataGridSource {
  _MyInteractionsDataSource(List<MyInteractionModel> interactions) {
    dataGridRows = List.generate(
      interactions.length,
      (i) => DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'type',
            value: interactions[i].type!.name,
          ),
          DataGridCell<String>(
            columnName: 'data',
            value: interactions[i].data,
          ),
        ],
      ),
    );
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    bool evenRow = rows.indexOf(row) % 2 == 0;
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color: evenRow
              ? Colors.transparent
              : MyColorHelper.red1.withOpacity(0.025),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value ?? '-',
            style: TextStyle(
              color: dataGridCell.columnName == 'detail' ? Colors.blue : null,
            ),
          ));
    }).toList());
  }
}
