import 'dart:async';

import 'package:app/helper/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPrivacyPolicy extends StatelessWidget {
  const MyPrivacyPolicy({super.key, this.dashboard = false});
  final bool dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dashboard
          ? null
          : AppBar(
              elevation: 0,
              title: Text('Privacy Policy'),
              foregroundColor: MyColorHelper.white,
              titleTextStyle: TextStyle(
                  color: MyColorHelper.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              backgroundColor: MyColorHelper.red1,
            ),
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _getPrivacyPolicy(),
        builder: (bContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: MyColorHelper.red1,
            ));
          } else {
            final List<Widget> list = [];
            if (snapshot.error == null && snapshot.hasData) {
              try {
                Map<String, dynamic> map =
                    (snapshot.data!.data() as Map<String, dynamic>);
                for (int i = 0; i < map.length; i++) {
                  for (String text in map['text${i + 1}'].split('\\n')) {
                    list.add(Text('$text',
                        style: TextStyle(
                            fontWeight: text.startsWith('###')
                                ? FontWeight.bold
                                : null)));
                  }
                }
              } catch (e) {}
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                // decoration: BoxDecoration(
                //   color: dashboard
                //       ? Colors.transparent
                //       : MyColorHelper.white.withOpacity(0.95),
                //   borderRadius: BorderRadius.circular(16.0),
                // ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list),
              ),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getPrivacyPolicy() async {
    return await FirebaseFirestore.instance
        .collection('essentials')
        .doc('privacy_policy')
        .get();
  }
}
