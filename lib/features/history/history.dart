import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../camera/components/bottom_sheet.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List<Map<String, dynamic>>> getHistory() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('history');

    // print(data);

    if (data == null || data.isEmpty) return [];

    // print(data);

    final List<Map<String, dynamic>> history =
        List<Map<String, dynamic>>.from(jsonDecode(data));
    print(history);
    return history;
  }

  void handleBottomSheet(
    BuildContext context,
    Map<String, dynamic> extractedData,
    Map<String, dynamic> healthEvaluation,
  ) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) => DataBottomSheet(extractedData, healthEvaluation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No History'),
            );
          }
          List<Map<String, dynamic>> histories = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: [
                for (final history in histories)
                  Card(
                    shadowColor: Colors.transparent,
                    child: ListTile(
                      title: Text(history['date']),
                      onTap: () {
                        handleBottomSheet(
                            context, history['data'], history['health']);
                      },
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
