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
          Card(
            shadowColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              title: const Text('Manage allergies'),
              trailing: const Icon(Symbols.arrow_right_rounded),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlergiesMenu(),
                );
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

class AlergiesMenu extends StatefulWidget {
  const AlergiesMenu({
    super.key,
  });

  @override
  State<AlergiesMenu> createState() => _AlergiesMenuState();
}

class _AlergiesMenuState extends State<AlergiesMenu> {
  final alergiesPrefsKey = 'alergies';
  final selectedAlergiesPrefsKey = 'selected_alergies';

  void saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(alergiesPrefsKey, alergies);
    prefs.setStringList(selectedAlergiesPrefsKey, selectedAlergies);
  }

  void loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAlergies = prefs.getStringList(alergiesPrefsKey);
    final savedSelectedAlergies = prefs.getStringList(selectedAlergiesPrefsKey);

    if (savedAlergies != null) {
      setState(() {
        alergies.clear();
        alergies.addAll(savedAlergies);
      });
    }

    if (savedSelectedAlergies != null) {
      setState(() {
        selectedAlergies.clear();
        selectedAlergies.addAll(savedSelectedAlergies);
      });
    }
  }

  List<String> alergies = [
    'Peanuts',
    'Gluten',
    'Lactose',
    'Seafood',
    'Soy',
    'Eggs',
    'Tree nuts',
    'Wheat',
    'Fish',
    'Shellfish',
  ];

  List<String> selectedAlergies = [];

  @override
  void initState() {
    super.initState();
    loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage allergies'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final alergie = alergies[index];
            final isSelected = selectedAlergies.contains(alergie);
            return CheckboxListTile(
              title: Text(alergie),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (isSelected) {
                    selectedAlergies.remove(alergie);
                  } else {
                    selectedAlergies.add(alergie);
                  }
                });
              },
            );
          },
          itemCount: alergies.length,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Add more allergies'),
                content: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter allergy',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      alergies.add(value);
                    });
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Add more'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            saveToPrefs();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
