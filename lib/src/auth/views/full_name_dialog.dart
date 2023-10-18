import 'dart:async';

import 'package:benaiah_mobile_app/core/extensions/context_extensions.dart';
import 'package:benaiah_mobile_app/core/services/injection_container.dart';
import 'package:benaiah_mobile_app/src/auth/controller/auth_controller.dart';
import 'package:benaiah_mobile_app/src/home/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FullNameDialog extends StatefulWidget {
  const FullNameDialog({super.key});

  @override
  State<FullNameDialog> createState() => _FullNameDialogState();
}

class _FullNameDialogState extends State<FullNameDialog> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool updating = false;

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final router = GoRouter.of(context);
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        updating = true;
                      });
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(controller.text.trim());
                      await sl<AuthenticationController>().register(
                        controller.text.trim(),
                      );
                      setState(() {
                        updating = false;
                      });
                      unawaited(router.pushReplacement(HomeScreen.path));
                    }
                  },
                  child: updating
                      ? const CircularProgressIndicator()
                      : const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
