import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  final String text;

  SamplePage({this.text = "Sample Page"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Page"),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
