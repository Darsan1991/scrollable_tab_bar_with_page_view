import 'package:flutter/material.dart';
import 'package:scrollable_tab_layout/page_view_widget.dart';
import 'package:scrollable_tab_layout/sample_page.dart';
import 'package:scrollable_tab_layout/tab_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 215, 215),
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
            leading: FlatButton(
              child: Image.asset("assets/home_icon.png"),
              onPressed: () {
                onPressHome(context);
              },
            ),
            title: Text(
              "Le mie serrature",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2),
            ),
            actions: <Widget>[
              Container(
                width: 55,
                height: 55,
                child: FlatButton(
                  child: Image.asset("assets/key_icon.png"),
                  onPressed: () {
                    onPressKey(context);
                  },
                ),
              )
            ],
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: PageViewWidget(
        [
          TabGroup(
            "Casa(4)",
            Center(
              child: TabCard(
                timeGroups: [
                  TabCardTimeGroup(time: "11:27", text: "Federica", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Robertino", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Ospite di Vercelli", open: false),
                ],
                onPressMenu: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SamplePage(
                      text: "Menu Page",
                    );
                  }));
                },
              ),
            ),
          ),
          TabGroup(
            "Casa al mare (4)",
            Center(
              child: TabCard(
                timeGroups: [
                  TabCardTimeGroup(
                      time: "15:27", text: "Federica", open: false),
                  TabCardTimeGroup(
                      time: "11:04", text: "Robertino", open: true),
                  TabCardTimeGroup(
                      time: "15:04", text: "Ospite di Vercelli", open: false),
                ],
                onPressMenu: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SamplePage(
                      text: "Menu Page",
                    );
                  }));
                },
              ),
            ),
          ),
          TabGroup(
            "Casa al ma (4)",
            Center(
              child: TabCard(
                timeGroups: [
                  TabCardTimeGroup(time: "11:27", text: "Federica", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Robertino", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Ospite di Vercelli", open: false),
                ],
                onPressMenu: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SamplePage(
                      text: "Menu Page",
                    );
                  }));
                },
              ),
            ),
          ),
          TabGroup(
            "Casa re (6)",
            Center(
              child: TabCard(
                timeGroups: [
                  TabCardTimeGroup(time: "11:27", text: "Federica", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Robertino", open: true),
                  TabCardTimeGroup(
                      time: "11:04", text: "Ospite di Vercelli", open: false),
                ],
                onPressMenu: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return SamplePage(
                      text: "Menu Page",
                    );
                  }));
                },
              ),
            ),
          ),
        ],
        viewPortFraction: 0.9,
      ),
    );
  }

  void onPressHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) {
        return SamplePage(
          text: "Home Page",
        );
      }),
    );
  }

  void onPressKey(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) {
        return SamplePage(
          text: "Key Page",
        );
      }),
    );
  }
}
