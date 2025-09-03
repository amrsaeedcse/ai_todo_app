import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.actions, required this.title});
  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: CustomText(text: title, fontWeight: FontWeight.w700, size: 30),
      centerTitle: false,
      titleSpacing: 20,
      automaticallyImplyLeading: false,
      actions: actions,
      actionsPadding: EdgeInsets.only(right: 20),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(70);
}
