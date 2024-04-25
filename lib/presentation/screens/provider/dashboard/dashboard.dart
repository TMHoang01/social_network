import 'package:flutter/material.dart';

class DashboardProviderScreen extends StatefulWidget {
  const DashboardProviderScreen({super.key});

  @override
  State<DashboardProviderScreen> createState() =>
      _DashboardProviderScreenState();
}

class _DashboardProviderScreenState extends State<DashboardProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Dashboard Provider Screen'),
      ),
    );
  }
}
