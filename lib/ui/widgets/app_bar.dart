import 'package:flutter/material.dart'; // use Material for AppBar

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("TaskAsync App"),
      centerTitle: true,
      elevation: 10,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
