import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../camera/components/bottom_sheet.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String gender = 'woman';
  String health = 'healthy';

  Future<String> getGender() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('gender') ?? 'man';
    return data;
  }

  String getHealth(List history) {
    String overallHealthiness = 'healthy';
    int healthy = 0;
    int unHealthy = 0;
    int moderatelyHealthy = 0;

    for (final data in history) {
      final health = data['health']['overall_healthiness']
          .toString()
          .toLowerCase()
          .replaceAll(' ', '_');

      print(data.keys);
      if (health == 'healthy') {
        healthy++;
      } else if (health == 'unhealthy') {
        unHealthy++;
      } else {
        moderatelyHealthy++;
      }
    }

    if (healthy > unHealthy && healthy > moderatelyHealthy) {
      overallHealthiness = 'healthy';
    } else if (unHealthy > healthy && unHealthy > moderatelyHealthy) {
      overallHealthiness = 'unhealthy';
    } else {
      overallHealthiness = 'moderately_healthy';
    }

    print(overallHealthiness);
    print('Healthy: $healthy');
    print('Unhealthy: $unHealthy');
    print('Moderately Healthy: $moderatelyHealthy');
    return overallHealthiness;
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('history');

    // print(data);

    if (data == null || data.isEmpty) return [];

    // print(data);

    final List<Map<String, dynamic>> history =
        List<Map<String, dynamic>>.from(jsonDecode(data));
    print(history);

    gender = await getGender();
    health = getHealth(history);

    return history;
  }

  void handleBottomSheet(
    BuildContext context,
    Map<String, dynamic> extractedData,
    Map<String, dynamic> healthEvaluation,
    Map<String, dynamic> allergiesFound,
  ) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) =>
          DataBottomSheet(extractedData, healthEvaluation, allergiesFound),
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
            displacement: 20,
            onRefresh: () async {
              setState(() {});
            },
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Image.asset('assets/images/${gender}_$health.png',
                        width: 150),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('History',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      for (final history in histories)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shadowColor: Colors.transparent,
                          child: ListTile(
                            title: Text(
                              DateFormat.yMMMMd()
                                  .format(DateTime.parse(history['date'])),
                            ),
                            subtitle: Text(DateFormat.Hm()
                                .format(DateTime.parse(history['date']))),
                            onTap: () {
                              handleBottomSheet(context, history['data'],
                                  history['health'], history['allergies']);
                            },
                          ),
                        ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
