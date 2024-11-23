import 'package:flutter/material.dart';
import 'package:schoolezy/pages/admin/pages/admin_dashboard/w_admin_dashboard.dart';
import 'package:schoolezy/pages/admin/pages/setup/view/m_admin_page.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size.width;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, builder) => windowSize > 700 ? const AdminDashboardPage() : const MobileAdminPage(),
      ),
    );
  }
}
