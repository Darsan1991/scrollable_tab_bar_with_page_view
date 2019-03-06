import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TestPage());
  }
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: PageViewPage([
        TabGroup(
            "Tab 1",
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(100, 30, 30, 30),
                            blurRadius: 15,
                            spreadRadius: 3)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )),
        TabGroup(
            "Tab 1",
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600),
                child: Container(
                  constraints: BoxConstraints.expand(),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(60, 30, 30, 30),
                            blurRadius: 15,
                            spreadRadius: 3)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            )),
      ]),
    );
  }
}

class PageViewPage extends StatefulWidget {
  final List<TabGroup> tabs;
  final double viewPortFraction;

  PageViewPage(this.tabs, {this.viewPortFraction = 0.8});

  @override
  PageViewPageState createState() {
    return new PageViewPageState();
  }
}

class PageViewPageState extends State<PageViewPage>
    with TickerProviderStateMixin {
  PageController _controller;
  TabController _tabController;
  bool _scrolling;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabs.length, initialIndex: 0, vsync: this);
    _controller = PageController(
        initialPage: 0,
        keepPage: true,
        viewportFraction: widget.viewPortFraction);
    _tabController.addListener(() {
      if (_scrolling) return;
      _controller.animateToPage(_tabController.index,
          duration: kTabScrollDuration, curve: Curves.ease);
    });

    _controller.addListener(() {
      // _controller.

      if ((_controller.page.round() - _controller.page).abs() < 0.05 ||
          (_controller.page.round() - _controller.page).abs() > 1)
        _tabController.index = _controller.page.round();
      _tabController.offset = _controller.page - _tabController.index;
    });

    Future.delayed(const Duration(seconds: 2), () {
      _controller.position.isScrollingNotifier.addListener(() {
        _scrolling = _controller.position.isScrollingNotifier.value;
        print("Scrolling ${this._scrolling}");
        // if (!_controller.position.isScrollingNotifier.value)
        //   _tabController.index = _controller.page.round();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Size:" + MediaQuery.of(context).size.width.toString());

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 230, 230, 230),
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromARGB(60, 50, 50, 50),
                offset: Offset(0, 2.0),
                blurRadius: 8.0,
              )
            ]),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.toys,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
              title: Text(
                "Le mie serrature",
                style: TextStyle(color: Colors.grey),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.vpn_key, color: Colors.grey),
                  onPressed: () {},
                )
              ],
              centerTitle: true,
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),

        // AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 5,
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.toys,
        //       color: Colors.grey,
        //     ),
        //     onPressed: () {},
        //   ),
        //   title: Text(
        //     "Le mie serrature",
        //     style: TextStyle(color: Colors.grey),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.vpn_key, color: Colors.grey),
        //       onPressed: () {},
        //     )
        //   ],
        //   centerTitle: true,
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              height: 23,
              child: TabBar(
                controller: _tabController,
                tabs: widget.tabs
                    .map((t) => Tab(
                          text: t.title,
                        ))
                    .toList(),
                labelColor: Colors.red,
                labelPadding: EdgeInsets.symmetric(horizontal: 25),
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                indicatorColor: Colors.red,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: Colors.red),
                    insets: EdgeInsets.symmetric(horizontal: 25.0)),
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
            Expanded(
              child: PageView(
                  controller: _controller,
                  children: widget.tabs.map((t) => t.tab).toList()),
            ),
            Container(
              height: 20,
              width: 50,
              color: Colors.indigo,
              margin: EdgeInsets.only(bottom: 15),
            ),
          ],
        ));
  }
}

class TabGroup {
  String title;
  Widget tab;

  TabGroup(this.title, this.tab);
}

// class TabPage extends StatefulWidget {
//   @override
//   TabPageState createState() {
//     return new TabPageState();
//   }
// }

// class TabPageState extends State<TabPage> with TickerProviderStateMixin {
//   TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 7, initialIndex: 0, vsync: this);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 230, 230, 230),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         toolbarOpacity: 0,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           SizedBox(
//             height: 15,
//           ),
//           Container(
//             height: 25,
//             child: TabBar(
//               controller: _tabController,
//               tabs: <Widget>[
//                 Tab(
//                   text: "Casa(4)",
//                 ),
//                 Tab(
//                   child: Text("Casa al mare(4)"),
//                 ),
//                 Tab(
//                   child: Text("Corte deglate(6)"),
//                 ),
//                 Tab(
//                   child: Text("Tab 1"),
//                 ),
//                 Tab(
//                   child: Text("Tab 1"),
//                 ),
//                 Tab(
//                   child: Text("Tab 1"),
//                 ),
//                 Tab(
//                   child: Text("Tab 1"),
//                 ),
//               ],
//               labelColor: Colors.red,
//               unselectedLabelColor: Colors.grey,
//               isScrollable: true,
//               indicatorColor: Colors.red,
//               indicator: UnderlineTabIndicator(
//                   borderSide: BorderSide(width: 3.0, color: Colors.red),
//                   insets: EdgeInsets.symmetric(horizontal: 16.0)),
//               labelStyle: TextStyle(fontWeight: FontWeight.w800),
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                   color: Colors.green,
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//                 Container(
//                   constraints: BoxConstraints.expand(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CustomTabBar extends TabBar {
//   CustomTabBar({
//     Key key,
//     @required List<Widget> tabs,
//     TabController controller,
//     bool isScrollable = true,
//     Color indicatorColor,
//     double indicatorWeight = 2.0,
//     EdgeInsets indicatorPadding = EdgeInsets.zero,
//     Decoration indicator,
//     TabBarIndicatorSize indicatorSize,
//     Color labelColor,
//     TextStyle labelStyle,
//     EdgeInsetsGeometry labelPadding,
//     Color unselectedLabelColor,
//     TextStyle unselectedLabelStyle,
//   }) : super(
//             key: key,
//             tabs: tabs,
//             controller: controller,
//             isScrollable: isScrollable,
//             indicatorWeight: indicatorWeight,
//             indicatorPadding: indicatorPadding,
//             indicator: indicator,
//             indicatorSize: indicatorSize,
//             labelColor: labelColor,
//             labelStyle: labelStyle,
//             labelPadding: labelPadding,
//             unselectedLabelColor: unselectedLabelColor,
//             unselectedLabelStyle: unselectedLabelStyle);

//   @override
//   Size get preferredSize {
//     return Size(super.preferredSize.width, 20);
//   }
// }
