import 'package:benaiah_mobile_app/core/extensions/context_extensions.dart';
import 'package:benaiah_mobile_app/core/services/injection_container.dart';
import 'package:benaiah_mobile_app/src/home/controller/home_controller.dart';
import 'package:flutter/material.dart';

class MotivationDialog extends StatefulWidget {
  const MotivationDialog({required this.updateNotifier, super.key});

  final ValueNotifier<int?> updateNotifier;

  @override
  State<MotivationDialog> createState() => _MotivationDialogState();
}

class _MotivationDialogState extends State<MotivationDialog> {
  ValueNotifier<int?> groupValue = ValueNotifier(null);
  ValueNotifier<bool> updatingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: groupValue,
      builder: (_, __) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: context.width * .3,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: context.theme.primaryColor,
              ),
              color: const Color(0xFFE8E8E8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    children: List.generate(
                      10,
                      (index) => SizedBox(
                        width: context.width / 3,
                        child: RadioListTile<int>.adaptive(
                          value: index + 1,
                          groupValue: groupValue.value,
                          tileColor: Colors.blue,
                          activeColor: context.theme.primaryColor,
                          onChanged: (value) {
                            groupValue.value = value;
                          },
                          title: Text((index + 1).toString()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: updatingNotifier,
                    builder: (_, __) {
                      return ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          updatingNotifier.value = true;
                          if (groupValue.value != null) {
                            await sl<HomeController>()
                                .submitMotivationLevel(groupValue.value!);
                            widget.updateNotifier.value = groupValue.value;
                          }
                          updatingNotifier.value = false;
                          navigator.pop();
                        },
                        child: updatingNotifier.value
                            ? const CircularProgressIndicator()
                            : const Text('Confirm'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
