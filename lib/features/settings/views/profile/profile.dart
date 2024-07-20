import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/rounded_appbar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> uselessProfile = [
      'Change name',
      'Change password',
      'Change email',
      'Change phone number',
      'Change address',
    ];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: RoundedAppBar(title: 'Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            shadowColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              title: const Text('Change gender'),
              trailing: const Icon(Symbols.arrow_right_rounded),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                        title: const Text('Change gender'),
                        children: [
                          ListTile(
                            title: const Text('Male'),
                            onTap: () {
                              prefs.setString('gender', 'man');
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: const Text('Female'),
                            onTap: () {
                              prefs.setString('gender', 'woman');
                              context.pop();
                            },
                          )
                        ]),
                  );
                }
              },
            ),
          ),
          for (final profile in uselessProfile)
            Card(
              shadowColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(profile),
                trailing: const Icon(Symbols.arrow_right_rounded),
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
