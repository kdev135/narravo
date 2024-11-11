import 'package:flutter/material.dart';

class CategoryListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryListTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 80,
      child: Card(
        child: ListTile(
          dense: true,
          leading: Icon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
