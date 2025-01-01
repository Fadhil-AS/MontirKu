import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String jenisKeluhan;
  final Widget leadingIcon;
  final Widget? trailingWidget;

  const NotificationCard({
    required this.title,
    required this.jenisKeluhan,
    required this.leadingIcon,
    this.trailingWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leadingIcon,
        title: Text(title),
        subtitle: Text(jenisKeluhan),
        trailing: trailingWidget,
      ),
    );
  }
}
