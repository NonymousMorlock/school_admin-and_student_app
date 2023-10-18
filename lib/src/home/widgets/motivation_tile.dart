import 'package:benaiah_mobile_app/src/home/models/local_user.dart';
import 'package:benaiah_mobile_app/src/home/widgets/motivation_dialog.dart';
import 'package:flutter/material.dart';

class MotivationTile extends StatefulWidget {
  const MotivationTile({required this.user, super.key});

  final LocalUser user;

  @override
  State<MotivationTile> createState() => _MotivationTileState();
}

class _MotivationTileState extends State<MotivationTile> {
  final ValueNotifier<int?> updateNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: updateNotifier,
      builder: (_, value, __) => Card(
        child: ListTile(
          title: Text(
            (widget.user.motivationLevelToday == null && value == null)
                ? 'What is your motivation level today?'
                : 'Motivation Level: '
                    '${widget.user.motivationLevelToday ?? value}',
          ),
          onTap: () async {
            if (widget.user.motivationLevelToday != null || value != null) {
              return;
            }
            await showDialog<void>(
              context: context,
              builder: (_) => MotivationDialog(updateNotifier: updateNotifier),
            );
          },
        ),
      ),
    );
  }
}
