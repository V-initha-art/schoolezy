import 'package:flutter/material.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/main_setup/pages/accounts_page.dart';

class WebMainSchoolSetupPage extends StatefulWidget {
  const WebMainSchoolSetupPage({super.key});

  @override
  State<WebMainSchoolSetupPage> createState() => _WebMainSchoolSetupPageState();
}

class _WebMainSchoolSetupPageState extends State<WebMainSchoolSetupPage> with TickerProviderStateMixin {
  final List<String> pages = [
    'School Accounts'
  ];

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: pages.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Setup'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: pages.map(Text.new).toList(),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [WebSchoolAccountPage()]),
    );
  }
}
