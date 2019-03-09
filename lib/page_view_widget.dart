import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_tab_layout/page_indicator_painter.dart';

class PageViewWidget extends StatefulWidget {
  final List<TabGroup> tabs;
  final double viewPortFraction;

  PageViewWidget(this.tabs, {this.viewPortFraction = 0.8});

  @override
  PageViewWidgetState createState() {
    return new PageViewWidgetState();
  }
}

class PageViewWidgetState extends State<PageViewWidget>
    with TickerProviderStateMixin {
  PageController _controller;
  TabController _tabController;
  bool _scrolling = false;
  double page = 0;
  bool _hasScrollerListenerAdded = false;

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
      _addScrollerListerIfNotAlreay();

      if ((_controller.page.round() - _controller.page).abs() < 0.05 ||
          (_controller.page.round() - _controller.page).abs() >= 1) {
        if (!_tabController.indexIsChanging)
          _tabController.index = _controller.page.round();
      }
      setState(() {
        this.page = _controller.page;
      });
      if (!_tabController.indexIsChanging)
        _tabController.offset =
            max(min(_controller.page - _tabController.index, 1), -1);
    });

    // Future.delayed(const Duration(seconds: 1), () {
    //   _controller.position.isScrollingNotifier.addListener(() {
    //     _scrolling = _controller.position.isScrollingNotifier.value;
    //   });
    // });
  }

  void _addScrollerListerIfNotAlreay() {
    if (_hasScrollerListenerAdded) return;
    _scrolling = _controller.position.isScrollingNotifier.value;
    _controller.position.isScrollingNotifier.addListener(() {
      _scrolling = _controller.position.isScrollingNotifier.value;
      // print("Scrolling ${this._scrolling}");
      // if (!_controller.position.isScrollingNotifier.value)
      //   _tabController.index = _controller.page.round();
    });
    _hasScrollerListenerAdded = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 18,
        ),
        Container(
          height: 25,
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
            labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
        ),
        Expanded(
          child: PageView(
              controller: _controller,
              children: widget.tabs.map((t) => t.tab).toList()),
        ),
        Container(
          height: 30,
          width: 200,
          margin: EdgeInsets.only(bottom: 15),
          child: CustomPaint(
            painter: PageIndicatorPainter(page, widget.tabs.length),
          ),
        ),
      ],
    );
  }
}

class TabGroup {
  String title;
  Widget tab;

  TabGroup(this.title, this.tab);
}
