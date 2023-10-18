import 'package:flutter/material.dart';

class OptionalExpanded extends StatelessWidget {
  const OptionalExpanded({
    required this.child,
    required this.expand,
    super.key,
  });

  final Widget child;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    if(expand) return Expanded(child: child);
    return child;
  }
}
