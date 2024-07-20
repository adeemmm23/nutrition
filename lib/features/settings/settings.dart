import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/state/color_bloc.dart';
import '../../global/state/theme_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 10),
          child:
              Text('Settings', style: Theme.of(context).textTheme.displaySmall),
        ),
        const SettingsTitle('Account'),
        SettingsCard(
          children: [
            SettingsListTile(
              trailing: const Icon(
                Symbols.arrow_forward_rounded,
                weight: 700,
              ),
              leading: const Icon(Symbols.key_rounded, weight: 700),
              title: 'Change profile',
              onTap: () {},
            ),
            const SettingsDivider(),
            SettingsListTile(
              trailing: const Icon(Symbols.arrow_forward_rounded, weight: 700),
              leading: const Icon(Symbols.lock_rounded, weight: 700),
              title: 'Logout',
              onTap: () {},
            ),
          ],
        ),
        const SettingsTitle('Visuals'),
        SettingsCard(
          children: [
            const SettingsListTile(
              leading: Icon(Symbols.color_lens_rounded, weight: 700),
              title: 'Change Theme',
            ),
            const SettingsColor(),
            const SettingsDivider(),
            SettingsListTile(
              trailing: Switch(
                thumbIcon: const MaterialStatePropertyAll(
                  Icon(Symbols.dark_mode_rounded, weight: 700),
                ),
                value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleThemeMode(
                        value ? ThemeState.dark : ThemeState.light,
                      );
                },
              ),
              leading: const Icon(Symbols.dark_mode_rounded, weight: 700),
              title: 'Dark Mode',
            ),
          ],
        ),
        const SettingsTitle('Support'),
        SettingsCard(
          children: [
            SettingsListTile(
              trailing: const Icon(Symbols.arrow_forward_rounded, weight: 700),
              leading: const Icon(Symbols.router, weight: 700),
              title: 'Change IP',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const SettingsIP(),
                );
              },
            ),
            const SettingsDivider(),
            SettingsListTile(
              trailing: const Icon(Symbols.arrow_forward_rounded, weight: 700),
              leading: const Icon(Symbols.privacy_tip_rounded, weight: 700),
              title: 'Privacy Policy',
              onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text('Your informations are safe! Don\'t worry :)'),
                // ));
                context.push('/privacy');
              },
            ),
            const SettingsDivider(),
            SettingsListTile(
              trailing: const Icon(Symbols.arrow_forward_rounded, weight: 700),
              leading: const Icon(Symbols.support, weight: 700),
              title: 'Support',
              onTap: () {
                context.push('/support');
              },
            ),
          ],
        ),
        const SettingsVerion(),
      ],
    ));
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(children: children),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final Widget? trailing;
  final Widget? leading;
  final String title;
  final VoidCallback? onTap;

  const SettingsListTile({
    super.key,
    this.trailing,
    this.leading,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 2.5),
      trailing: trailing,
      leading: leading,
      title: Text(title),
      onTap: onTap,
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      thickness: 2,
      color: Theme.of(context).colorScheme.background,
    );
  }
}

class SettingsTitle extends StatelessWidget {
  const SettingsTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 20, bottom: 10),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class SettingsVerion extends StatelessWidget {
  const SettingsVerion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'Version 1.0.0',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class SettingsColor extends StatefulWidget {
  const SettingsColor({super.key});

  @override
  State<SettingsColor> createState() => _SettingsColorState();
}

class _SettingsColorState extends State<SettingsColor> {
  Set<ColorState> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 20),
      child: SegmentedButton(
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        selected: _selected,
        segments: [
          ButtonSegment(
            value: ColorState.red,
            label: Icon(
              Symbols.circle,
              fill: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.red.shade200
                  : Colors.red.shade400,
            ),
          ),
          ButtonSegment(
            value: ColorState.teal,
            label: Icon(
              Symbols.circle,
              fill: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.teal.shade200
                  : Colors.teal.shade400,
            ),
          ),
          ButtonSegment(
            value: ColorState.blue,
            label: Icon(
              Symbols.circle,
              fill: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue.shade200
                  : Colors.blue.shade400,
            ),
          ),
          ButtonSegment(
            value: ColorState.purple,
            label: Icon(
              Symbols.circle,
              fill: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.purple.shade200
                  : Colors.purple.shade400,
            ),
          ),
          ButtonSegment(
            value: ColorState.orange,
            label: Icon(
              Symbols.circle,
              fill: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.orangeAccent.shade200
                  : Colors.orangeAccent.shade400,
            ),
          ),
        ],
        onSelectionChanged: (value) {
          if (value.isEmpty) return;
          context.read<ColorCubit>().setColors(value.last);
          setState(() {
            _selected = value;
          });
        },
      ),
    );
  }
}

class SettingsIP extends StatefulWidget {
  const SettingsIP({super.key});

  @override
  State<SettingsIP> createState() => _SettingsIPState();
}

class _SettingsIPState extends State<SettingsIP> {
  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String currentIP = 'Tap to change';

  void submit() async {
    if (!formKey.currentState!.validate()) {
      setState(() {
        currentIP = 'Invalid IP address';
      });
      return;
    }
    final ip = textController.text;
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('ip', ip);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('IP address changed successfully!'),
        ));
      }
    } on Exception catch (_) {
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to change IP address!'),
        ));
      }
    }
  }

  String? ipValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an IP address';
    }

    final ipv4Pattern = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );

    if (!ipv4Pattern.hasMatch(value)) {
      return 'Please enter a valid IP address';
    }

    final segments = value.split('.');

    for (final segment in segments) {
      final number = int.tryParse(segment);
      if (number == null || number < 0 || number > 255) {
        return 'Please enter a valid IP address';
      }
    }
    return null;
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then(
      (value) => setState(() {
        final oldIP = value.getString('ip');
        currentIP = oldIP == null ? currentIP : 'Current IP: $oldIP';
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: TextFormField(
              keyboardType: TextInputType.number,
              autofocus: true,
              onFieldSubmitted: (_) => submit(),
              validator: ipValidator,
              textAlignVertical: TextAlignVertical.center,
              controller: textController,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 0.01),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: submit,
                    icon: const Icon(Icons.arrow_right),
                  ),
                ),
                hintText: 'Change IP Address',
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.background.withAlpha(90),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currentIP,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}
