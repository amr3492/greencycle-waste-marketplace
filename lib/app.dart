/// Root widget: theme, auth gate, and the four main pages from the deck
/// (Home / Recycle / Marketplace / Profile) plus role-specific pages
/// for the Employee and Admin actors.
library;

import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/models.dart';
import 'core/theme.dart';
import 'features/admin/admin_screen.dart';
import 'features/auth/auth_screens.dart';
import 'features/employee/employee_screen.dart';
import 'features/home/home_screen.dart';
import 'features/market/marketplace_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/recycle/recycle_flow.dart';

class GreenCycleApp extends StatelessWidget {
  const GreenCycleApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'GreenCycle',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (state.currentUser == null) return const LoginScreen();
    return const _MainShell();
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final role = state.currentUser!.role;

    final pages = <Widget>[
      const HomeScreen(),
      const RecycleTabScreen(),
      const MarketplaceScreen(),
      const ProfileScreen(),
      if (role == UserRole.employee) const EmployeeScreen(),
      if (role == UserRole.admin) const AdminScreen(),
    ];
    final destinations = <NavigationDestination>[
      const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home'),
      const NavigationDestination(
          icon: Icon(Icons.recycling_outlined),
          selectedIcon: Icon(Icons.recycling),
          label: 'Recycle'),
      const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Market'),
      const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile'),
      if (role == UserRole.employee)
        const NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Route'),
      if (role == UserRole.admin)
        const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin'),
    ];

    final index = _index.clamp(0, pages.length - 1);
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }
}
