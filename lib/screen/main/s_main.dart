import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/main/tab/tab_item.dart';
import 'package:fast_app_base/screen/main/tab/tab_navigator.dart';
import 'package:fast_app_base/screen/main/write/d_write.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'w_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.Todo;
  final tabs = [TabItem.Todo, TabItem.Search];
  final List<GlobalKey<NavigatorState>> navigatorKeys = [];

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey => navigatorKeys[_currentIndex];

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;

  @override
  void initState() {
    super.initState();
    initNavigatorKeys();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        extendBody: extendBody, //bottomNavigationBar 아래 영역 까지 그림
        drawer: const MenuDrawer(),
        body: Container(
          color: context.appColors.seedColor.getMaterialColorValues[200],
          padding: EdgeInsets.only(bottom: extendBody ? 60 - bottomNavigationBarBorderRadius : 0),
          child: SafeArea(
            bottom: !extendBody,
            child: pages,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // WriteTodoResult? 타입으로 받음 (WriteTodoDialog의 13줄에 명시해서)
            final result = await WriteTodoDialog().show();
            if (result != null && mounted) {
              // await 이후에 context가 유효하지 않게 될 수 있어 아래 부분 문제될 수도 있다. 그래서 mounted여부도 체크
              // mounted는 현재 스크린이 살아있는지 체크
              context.holder.notifier.addTodo(Todo(
                id: DateTime.now().millisecondsSinceEpoch,
                title: result.text,
                dueDate: result.dateTime,
              ));
              //debugPrint(result.text);
              //debugPrint(result.dateTime.formattedDate);
            }
          },
          child: const Icon(EvaIcons.plus),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
                offstage: _currentTab != tab,
                child: TabNavigator(
                  navigatorKey: navigatorKeys[index],
                  tabItem: tab,
                ),
              ))
          .toList());

  Future<bool> _handleBackPressed() async {
    final isFirstRouteInCurrentTab = (await _currentTabNavigationKey.currentState?.maybePop() == false);
    if (isFirstRouteInCurrentTab) {
      if (_currentTab != TabItem.Todo) {
        _changeTab(tabs.indexOf(TabItem.Todo));
        return false;
      }
    }
    // maybePop 가능하면 나가지 않는다.
    return isFirstRouteInCurrentTab;
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.text,
          unselectedItemColor: context.appColors.iconButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
            context,
            isActivated: _currentIndex == index,
          ),
        )
        .toList();
  }

  void _changeTab(int index) {
    setState(() {
      _currentTab = tabs[index];
    });
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData, IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }

  void initNavigatorKeys() {
    for (final _ in tabs) {
      navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }
}
