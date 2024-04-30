import 'package:flutter/material.dart';
import 'package:flutter_extras/pages/settings.dart';
import 'package:flutter_extras/pages/map.dart';
import 'package:flutter_extras/pages/contact.dart';
import 'package:flutter_extras/pages/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16.0),
    ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black45,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      ),
    );
  }
}



class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: const HomePage(),
      icon: const Icon(Icons.home),
      title: "Home",
    ),
    TabNavigationItem(
      page: const ContactPage(),
      icon: const Icon(Icons.email),
      title: "Contact",
    ),
    TabNavigationItem(
      page: const SettingsPage(),
      icon: const Icon(Icons.settings),
      title: "Settings",
    ),
    TabNavigationItem(
      page: const MapPage(),
      icon: const Icon(Icons.map),
      title: "Map",
    ),
  ];
}

