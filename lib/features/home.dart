import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../components/animated_symbols.dart';
import 'history/history.dart';
import 'settings/settings.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/logo/logo.png',
          height: 25,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: PageView(
        controller: pageViewController,
        onPageChanged: (index) {
          setState(() {
            if (index == 1) {
              selectedIndex = 2;
            } else {
              selectedIndex = index;
            }
          });
        },
        children: const [
          History(),
          Settings(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/ai');
        },
        child: const Icon(
          Symbols.smart_toy_rounded,
          weight: 600,
          opticalSize: 28,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: AnimatedSymbol(
              selected: selectedIndex == 0,
              symbol: Symbols.book_rounded,
            ),
            label: 'History',
          ),
          FilledButton(
            onPressed: () {
              context.push('/camera');
            },
            child: const Icon(
              Symbols.barcode_scanner_rounded,
              weight: 600,
              opticalSize: 28,
            ),
          ),
          NavigationDestination(
            icon: AnimatedSymbol(
              selected: selectedIndex == 2,
              symbol: Symbols.settings_rounded,
            ),
            label: 'Settings',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: _navigate,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }

  void _navigate(index) {
    setState(
      () {
        if (index == 2) {
          pageViewController.animateToPage(
            1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        } else {
          pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }
}
