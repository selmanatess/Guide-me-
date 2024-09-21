import 'package:flutter/material.dart';

class Selectsubscribe extends StatefulWidget {
  const Selectsubscribe({super.key});

  @override
  State<Selectsubscribe> createState() => _SelectsubscribeState();
}

class _SelectsubscribeState extends State<Selectsubscribe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //container for the title
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select Subscription",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
