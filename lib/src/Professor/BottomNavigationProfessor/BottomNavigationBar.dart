import 'dart:ui';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:censeo/resources/professorIcons.dart';
import 'package:censeo/src/Professor/BottomNavigationProfessor/TabNavigatorProfessor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

enum TabItem { aulas, dados, sugestoes }

class BottomNavigationProfessor extends StatefulWidget {
  @override
  _BottomNavigationProfessorState createState() => _BottomNavigationProfessorState();
}

class _BottomNavigationProfessorState extends State<BottomNavigationProfessor> {
  int currentIndex;
  TabItem _currentTab = TabItem.aulas;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.aulas: GlobalKey<NavigatorState>(),
    TabItem.dados: GlobalKey<NavigatorState>(),
    TabItem.sugestoes: GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  static madeBubbleBottomBarItem(IconData icon, String title) {
    return BubbleBottomBarItem(
      backgroundColor: Color(0xFFFF3F85),
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
    madeBubbleBottomBarItem(ProfessorIcons.chalkboard, "Aulas"),
    madeBubbleBottomBarItem(ProfessorIcons.chalkboard, "Aulas"),
    madeBubbleBottomBarItem(ProfessorIcons.chart, "Dados"),
    madeBubbleBottomBarItem(ProfessorIcons.chat, "Sugestões"),
  ];

  static final mapPag = {
    0: TabItem.aulas,
    1: TabItem.aulas,
    2: TabItem.dados,
    3: TabItem.sugestoes,
  };

  void changePage(int i) {
    setState(() {
      _selectTab(mapPag[i]);
      currentIndex = i;
    });
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    const Map itemToNavigator = {
      TabItem.aulas: '/class',
      TabItem.dados: '/data',
      TabItem.sugestoes: '/suggestions',
    };

    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        navigator: itemToNavigator[tabItem],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentTab].currentState.maybePop();

        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.aulas) {
            // select 'main' tab
            _selectTab(TabItem.aulas);
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
            _buildOffstageNavigator(TabItem.aulas),
            _buildOffstageNavigator(TabItem.dados),
            _buildOffstageNavigator(TabItem.sugestoes),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectTab(TabItem.aulas);
                currentIndex = 1;
              });
            },
            child: Icon(
              ProfessorIcons.chalkboard,
              color: Colors.white,
              size: 25,
            ),
            backgroundColor: Color(0xFFFF3F85),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
