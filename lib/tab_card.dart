import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:intl/intl.dart';

class TabCard extends StatefulWidget {
  final Battery battery;
  final String title;
  final String icon;
  final List<TabCardTimeGroup> timeGroups;
  final Function onPressPositive;
  final Function onPressNegative;
  final Function onPressMenu;

  TabCard({
    this.title = "Portone principale",
    this.icon = "assets/door_icon.png",
    this.timeGroups = const [],
    this.onPressPositive,
    this.onPressNegative,
    this.onPressMenu,
  }) : battery = Battery();

  @override
  TabCardState createState() {
    return new TabCardState();
  }
}

class TabCardState extends State<TabCard> {
  double batteryLevel = 0;

  DateTime _time;
  Timer _timer;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    widget.battery.batteryLevel.then((lvl) {
      if (_disposed) return;
      setState(() {
        batteryLevel = lvl / 100.0;
      });
    });

    _time = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 580),
      child: Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color.fromARGB(70, 30, 30, 30),
              blurRadius: 15,
              offset: Offset(0, 3),
              spreadRadius: 3)
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Positioned(
                      left: 18,
                      top: 18,
                      child: BatteryWidget(batteryLevel),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        child: FlatButton(
                          child: Image.asset("assets/menu_icon.png"),
                          onPressed: () {
                            if (widget.onPressMenu != null)
                              widget.onPressMenu();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(DateFormat.Hm().format(_time),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    )
                  ],
                ),
                height: 50,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 240, 240, 240)),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image.asset(
                      widget.icon,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildTimeRows(widget.title, widget.timeGroups)
                      // <Widget>[
                      //   Text(
                      //     widget.title,
                      //     style: TextStyle(
                      //         fontSize: 30, fontWeight: FontWeight.w800),
                      //   ),
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      //   _buildTimeRow(
                      //       "assets/close.png", Colors.red, "12:28", "Federica"),
                      //   SizedBox(
                      //     height: 5,
                      //   ),
                      //   _buildTimeRow(
                      //       "assets/open.png", Colors.green, "11:28", "Federica"),
                      //   SizedBox(
                      //     height: 5,
                      //   ),
                      //   _buildTimeRow(
                      //       "assets/open.png", Colors.green, "11:28", "Federica"),
                      // ],
                      ),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: _buildButton(
                        "CHIUDI",
                        Color.fromARGB(255, 254, 23, 23),
                        Color.fromARGB(255, 240, 240, 240),
                        "assets/close.png",
                        () {
                          if (widget.onPressNegative != null)
                            widget.onPressNegative();
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildButton(
                        "APRI",
                        Colors.white,
                        Color.fromARGB(255, 0, 203, 39),
                        "assets/open.png",
                        () {
                          if (widget.onPressNegative != null)
                            widget.onPressPositive();
                        },
                      ),
                    )
                  ],
                ),
                height: 70,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimeRows(String title, List<TabCardTimeGroup> groups) {
    var widgetList = List<Widget>();

    widgetList.add(Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
    ));
    widgetList.add(SizedBox(
      height: 10,
    ));

    for (var i = 0; i < groups.length; i++) {
      widgetList.add(_buildTimeRow(
          groups[i].open ? "assets/open.png" : "assets/close.png",
          groups[i].open ? Colors.green : Colors.red,
          groups[i].time,
          groups[i].text));
      if (i < groups.length - 1) {
        widgetList.add(SizedBox(
          height: 5,
        ));
      }
    }
    return widgetList;
  }

  Widget _buildTimeRow(String icon, Color color, String time, String text) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          icon,
          width: 15,
          color: color,
        ),
        RichText(
          text: TextSpan(text: "", style: TextStyle(), children: [
            TextSpan(
                text: " $time | ",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color.fromARGB(255, 100, 100, 100),
                  decoration: null,
                )),
            TextSpan(
                text: text, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ]),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, Color bgColor, String icon,
      Function onPressed) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                width: 22,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 17,
                    letterSpacing: 2),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Color.fromARGB(0, 0, 0, 0),
            child: InkWell(
              onTap: onPressed,
            ),
          ),
        )
      ],
    );
  }
}

class TabCardTimeGroup {
  bool open;
  String time;
  String text;

  TabCardTimeGroup({this.time, this.open, this.text});
}

class BatteryWidget extends StatelessWidget {
  final double value;

  BatteryWidget(this.value);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/battery_icon.png",
          width: 30,
        ),
        Positioned(
          left: 3.5,
          right: 7,
          top: 3,
          bottom: 3,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: (100 * value).toInt(),
                child: Container(
                  color: Colors.black87,
                ),
              ),
              Expanded(
                flex: (100 - 100 * value).toInt(),
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
