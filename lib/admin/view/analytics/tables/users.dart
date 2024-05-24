part of '../page.dart';

class _MyUsersTable extends StatelessWidget {
  const _MyUsersTable(this.controller);
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
                  source: _UsersDataSource(controller.usersAnalytics),
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: [
                    _column('fullName', 'Full Name'),
                    _column('userType', 'User Type'),
                    _column('status', 'Status'),
                    _column('detail', 'Detail'),
                  ],
                  onCellTap: (DataGridCellTapDetails details) {
                    if (details.column.columnName == 'detail' &&
                        details.rowColumnIndex.rowIndex != 0) {
                      showDialog(
                        context: context,
                        builder: (dContext) => MyUserDetailDialog(
                          controller.usersAnalytics[
                              details.rowColumnIndex.rowIndex - 1],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  GridColumn _column(String name, String value) => GridColumn(
      columnName: name,
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

class _UsersDataSource extends DataGridSource {
  _UsersDataSource(List<MyUserModel> users) {
    dataGridRows = List.generate(
      users.length,
      (i) => DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'fullName',
            value: users[i].fullName,
          ),
          DataGridCell<String>(
            columnName: 'userType',
            value: users[i].userType == MyUserType.admin
                ? 'Admin'
                : users[i].userType == MyUserType.user
                    ? 'Manager'
                    : users[i].userType == MyUserType.prMember
                        ? 'PR Member'
                        : users[i].userType == MyUserType.mediaMember
                            ? 'Media Member'
                            : '-',
          ),
          DataGridCell<String>(
            columnName: 'status',
            value: users[i].status == true
                ? 'Active'
                : users[i].status == false
                    ? 'Inactive'
                    : '-',
          ),
          const DataGridCell<String>(
            columnName: 'detail',
            value: 'View',
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
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: dataGridCell.columnName == 'detail' ? Colors.blue : null,
            ),
          ));
    }).toList());
  }
}
