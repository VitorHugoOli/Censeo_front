import 'dart:ui';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:censeo/main.dart';
import 'package:censeo/resources/constant.dart';
import 'package:censeo/src/Aluno/BottomNavigationProfessor/TabNavigatorAluno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';

enum TabItem { avaliar, rank, sugestoes }

class BottomNavigationAluno extends StatefulWidget {
  @override
  _BottomNavigationAlunoState createState() => _BottomNavigationAlunoState();
}

class _BottomNavigationAlunoState extends State<BottomNavigationAluno> {
  late int currentIndex;
  TabItem _currentTab = TabItem.avaliar;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.avaliar: GlobalKey<NavigatorState>(),
    TabItem.rank: GlobalKey<NavigatorState>(),
    TabItem.sugestoes: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  static madeBubbleBottomBarItem(IconData icon, String title) {
    return BubbleBottomBarItem(
      backgroundColor: Color(0xFF3D5AF1),
      icon: Icon(
        icon,
        color: Color(0xFF383838),
      ),
      activeIcon: Icon(
        icon,
        color: Color(0xFFFFFFFF),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Color(0xffffffff),
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.63,
        ),
      ),
    );
  }

  static final List<BubbleBottomBarItem> barItens = <BubbleBottomBarItem>[
    madeBubbleBottomBarItem(FeatherIcons.star, "Avaliar"),
    madeBubbleBottomBarItem(FeatherIcons.star, "Avaliar"),
    madeBubbleBottomBarItem(FeatherIcons.barChart, "Rank"),
    madeBubbleBottomBarItem(FeatherIcons.trendingUp, "Sugestões"),
  ];

  static final mapPag = {
    0: TabItem.avaliar,
    1: TabItem.avaliar,
    2: TabItem.rank,
    3: TabItem.sugestoes,
  };

  void changePage(int? i) {
    setState(() {
      _selectTab(mapPag[i]!);
      currentIndex = i ?? 0;
    });
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    const Map itemToNavigator = {
      TabItem.avaliar: '/classAluno',
      TabItem.rank: '/rank',
      TabItem.sugestoes: '/suggestions',
    };

    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        navigator: itemToNavigator[tabItem],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.avaliar) {
            // select 'main' tab
            _selectTab(TabItem.avaliar);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItem.avaliar),
            _buildOffstageNavigator(TabItem.rank),
            _buildOffstageNavigator(TabItem.sugestoes),
          ]),
          floatingActionButton: Visibility(
            visible:
                MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom ==
                    0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectTab(TabItem.avaliar);
                  currentIndex = 1;
                });
              },
              child: Icon(
                FeatherIcons.star,
                color: Colors.white,
                size: 25,
              ),
              backgroundColor: Color(0xFF3D5AF1),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BubbleBottomBar(
              opacity: 1,
              fabLocation: BubbleBottomBarFabLocation.center,
              currentIndex: currentIndex,
              onTap: changePage,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              //border radius doesn't work when the notch is enabled.
              elevation: 8,
              items: barItens),
        ),
      ),
    );
  }
}
