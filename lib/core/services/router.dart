import 'package:benaiah_mobile_app/core/extensions/context_extensions.dart';
import 'package:benaiah_mobile_app/src/auth/views/full_name_dialog.dart';
import 'package:benaiah_mobile_app/src/home/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:native_dialog/native_dialog.dart';

final authFailed = AuthStateChangeAction<AuthFailed>((context, state) {
  final exception = state.exception;
  // if (kIsWeb &&
  //     (defaultTargetPlatform != TargetPlatform.iOS &&
  //         defaultTargetPlatform != TargetPlatform.android)) {
  //   NativeDialog.alert(
  //     exception is FirebaseException
  //         ? (exception.message ?? 'Unknown Error Occurred')
  //         : exception.toString(),
  //   );
  //   return;
  // }
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog.adaptive(
      title: Text(
        exception is FirebaseException ? exception.code : 'Error Occurred',
      ),
      content: Text(
        exception is FirebaseException
            ? (exception.message ?? 'Unknown Error Occurred')
            : exception.toString(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
});

final router = GoRouter(
  routes: [
    GoRoute(
      path: HomeScreen.path,
      pageBuilder: (_, state) {
        return _pageBuilder(
          const HomeScreen(),
          state: state,
        );
      },
      redirect: (_, __) async {
        var user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          user = await FirebaseAuth.instance.authStateChanges().first;
          if (user == null || user.displayName == null) {
            return '/sign-in';
          }
        }
        return HomeScreen.path;
      },
    ),
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, goState) => _pageBuilder(
        SignInScreen(
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              if (!state.user!.emailVerified) {
                context.go('/verify-email');
              } else if (state.user!.displayName == null) {
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return const FullNameDialog();
                  },
                );
              } else {
                context.pushReplacement(HomeScreen.path);
              }
            }),
            authFailed,
          ],
        ),
        state: goState,
      ),
    ),
    GoRoute(
      path: '/sign-up',
      pageBuilder: (_, goState) => _pageBuilder(
        RegisterScreen(
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) async {
              if (!state.credential.user!.emailVerified) {
                GoRouter.of(context).go('/verify-email');
              }
            }),
            authFailed,
          ],
        ),
        state: goState,
      ),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => _pageBuilder(
        ProfileScreen(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(HomeScreen.path);
                }
              },
              icon: Icon(
                context.theme.platform == TargetPlatform.iOS
                    ? Icons.arrow_back_ios_new
                    : Icons.arrow_back,
              ),
            ),
          ),
          actions: [
            SignedOutAction((context) {
              context.pushReplacement(HomeScreen.path);
            }),
          ],
        ),
        state: state,
      ),
      redirect: (_, __) {
        if (FirebaseAuth.instance.currentUser == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/verify-email',
      pageBuilder: (context, state) => _pageBuilder(
        EmailVerificationScreen(
          actions: [
            EmailVerifiedAction(() {
              context.pushReplacement(HomeScreen.path);
            }),
            AuthCancelledAction((context) {
              FirebaseUIAuth.signOut(context: context);
              context.pushReplacement(HomeScreen.path);
            }),
            authFailed,
          ],
        ),
        state: state,
      ),
    ),
  ],
);

Page<dynamic> _pageBuilder(Widget page, {required GoRouterState state}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: page,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      child: child,
    ),
  );
}
