part of 'screen.dart';

class _MySideBar extends StatelessWidget {
  const _MySideBar(this.controller, this.data, this.scaffoldKey);
  final SidebarXController controller;
  final List<MyDashboardModel> data;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      showToggleButton: false,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
          color: MyColorHelper.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        margin: const EdgeInsets.all(12.0),
        itemPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12.0,
        ),
        selectedItemPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12.0,
        ),
        hoverColor: MyColorHelper.red.withOpacity(0.15),
        hoverTextStyle: const TextStyle(color: MyColorHelper.black1),
        textStyle: const TextStyle(color: MyColorHelper.black1),
        selectedTextStyle: const TextStyle(
          color: MyColorHelper.red1,
          fontWeight: FontWeight.bold,
        ),
        itemTextPadding: const EdgeInsets.only(left: 32),
        selectedItemTextPadding: const EdgeInsets.only(left: 32),
        itemDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: MyColorHelper.red1),
          gradient: LinearGradient(
            colors: [MyColorHelper.red.withOpacity(0.25), MyColorHelper.white],
            stops: const [0.0, 1.0],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        iconTheme: const IconThemeData(color: MyColorHelper.black1, size: 20),
        selectedIconTheme:
            const IconThemeData(color: MyColorHelper.red, size: 20),
      ),
      extendedTheme: const SidebarXTheme(
        width: 250,
        decoration: BoxDecoration(color: MyColorHelper.white),
      ),
      headerBuilder: (context, extended) {
        return InkWell(
          onTap: () {
            controller.selectIndex(0);
            adminUniversalController.setTabIndex(0);
            scaffoldKey.currentState?.closeDrawer();
          },
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        );
      },
      items: data
          .map(
            (e) => SidebarXItem(
              icon: e.icon,
              label: e.title,
              onTap: () {
                if (!adminUniversalController.loading) {
                  adminUniversalController.setTabIndex(data.indexOf(e));
                  scaffoldKey.currentState?.closeDrawer();
                }
              },
            ),
          )
          .toList(),
      footerBuilder: (context, extend) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '© 2024 RTSC, INC. ALL RIGHTS RESERVED.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
