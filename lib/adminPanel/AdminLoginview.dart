import 'package:flutter/material.dart';

import 'package:iw_admin_panel/adminPanel/responsive.dart';
import 'package:iw_admin_panel/adminPanel/utils.dart';
import 'package:iw_admin_panel/adminPanel/utils/DesktopBody.dart';


class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        desktopBody: DesktopBody(), mobileBody: MobileBody());
  }
}
