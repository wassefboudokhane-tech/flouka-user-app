import 'package:flutter/material.dart';


class SettingsSectionContainer extends StatelessWidget {
  final List<Widget> children;

  const SettingsSectionContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
