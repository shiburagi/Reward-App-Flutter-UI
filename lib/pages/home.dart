import 'dart:ui';

import 'package:dashboard_template/components/coordinator_layout.dart';
import 'package:dashboard_template/components/header.dart';
import 'package:dashboard_template/dummies/transaction.dart';
import 'package:dashboard_template/views/categories.dart';
import 'package:dashboard_template/views/items.dart';
import 'package:dashboard_template/views/summary_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Menu {
  final IconData icon;
  final String title;

  Menu(this.icon, this.title);
}

List<Menu> menus = [
  Menu(Icons.home, "Home"),
  Menu(Icons.multiline_chart, "Visualize"),
  Menu(Icons.card_giftcard, "Reward"),
  Menu(Icons.settings, "Settings"),
];

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  double minHeight;
  double maxHeight;
  int maxValue = 1000;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    minHeight ??= MediaQuery.of(context).padding.top + kToolbarHeight;
    maxHeight ??= 360;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CoordinatorLayout(
              snap: true,
              scrollController: scrollController,
              header: buildCollapseHeader(context),
              body: buildMainContent(context),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).canvasColor,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Theme.of(context).disabledColor,
              selectedItemColor: Theme.of(context).accentColor,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: menus
                  .map((e) => BottomNavigationBarItem(
                        icon: Icon(e.icon),
                        title: Text(e.title),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchBox() {
    double height = 48;
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2)),
      child: Container(
        height: height,
        padding: EdgeInsets.only(left: height / 2, right: height / 2 - 12),
        child: TextFormField(
          autofocus: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 16, bottom: 14),
            hintText: "What you wish for?",
            suffixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            CategoriesList(),
            buildSearchBox(),
            SizedBox(
              height: 24,
            ),
            ItemList(label: "New"),
            ItemList(label: "Hot"),
          ],
        ),
      ),
    );
  }

  NumberFormat _numberFormat = NumberFormat("###,###,###");

  Card buildPointSummary(
      {String title, double value, Color color, Widget icon, double rate}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Theme.of(context).hintColor)),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Text(_numberFormat.format(value),
                          style: Theme.of(context).textTheme.headline4),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 1,
                        height: 12,
                        color: Theme.of(context).dividerColor,
                      ),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Icon(
                              rate > 0
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: rate > 0
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                              size: 24),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(_numberFormat.format(rate),
                                style: Theme.of(context).textTheme.caption),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: FloatingActionButton.extended(
                heroTag: "view-transaction",
                onPressed: () {
                  Navigator.of(context).pushNamed("/transaction");
                },
                label: Text("View"),
              ),
            )
          ],
        ),
      ),
    );
  }

  double offset = 0;
  SliverCollapseHeader buildCollapseHeader(BuildContext context) {
    return SliverCollapseHeader(
      minHeight: minHeight + 100,
      maxHeight: maxHeight,
      builder: (context, offset) {
        this.offset = offset;
        return Stack(
          children: <Widget>[
            Positioned.fill(
              bottom: 50,
              child: buildHeader(context, offset),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: buildPointSummary(
                        title: "Received",
                        value: 10000 + sum(totalReceived),
                        rate: totalReceived.last.y - totalRedeem.last.y,
                        color: Colors.green,
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildHeader(BuildContext context, double offset) {
    return IgnorePointer(
      ignoring: false,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark,
            ]),
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16 * (1 - offset)))),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: maxHeight - 50,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 24 * (1 - offset),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: false,
                    title: Container(
                      child: Text(
                        offset == 1 ? "Home" : "Hi Michael,",
                        style: TextStyle(fontSize: 18 + 16 * (1 - offset)),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          debugPrint("clicl");
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: kToolbarHeight + 90,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    child: Opacity(
                      opacity: 1 - offset,
                      child: SummaryChart(
                        data1: totalReceived,
                        data2: totalRedeem,
                        maxValue: maxValue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double sum(List<FlSpot> data1) {
    return data1.fold(
      0,
      (previousValue, element) => previousValue + element.y,
    );
  }
}
