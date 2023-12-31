import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instagram_clone/state/providers/is_loading_provider.dart';
import 'package:instagram_clone/views/components/loading/loading_screen.dart';
import 'package:instagram_clone/views/login/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:developer' as devtools show log;

import 'views/main/main_view.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Consumer(builder: (context, ref, child) {
        ref.listen(isLoadingProvider, (_, isLoading) {
          if (isLoading) {
            LoadingScreen.instance().show(
              context: context,
            );
          } else {
            LoadingScreen.instance().hide();
          }
        });
        final isLoggedIn = ref.watch(isLoggedInProvider);
        if (isLoggedIn) {
          return const MainView();
        } else {
          return const LoginView();
        }
      }),
    );
  }
}

// // for when you are already logged in
// class MainView extends ConsumerWidget {
//   const MainView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Main View'),
//         ),
//       ),
//       body: TextButton(
//         onPressed: () async {
//           await ref.read(authStateProvider.notifier).logOut();
//         },
//         child: const Text(
//           'Logout',
//         ),
//       ),
//     );
//   }
// }

// class LoginView extends StatelessWidget {
//   const LoginView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text('Login View'),
//         ),
//       ),
//       body: Column(
//         children: [
//           Consumer(
//             builder: (context, ref, child) {
//               return TextButton(
//                 onPressed: () async {
//                   await ref.watch(authStateProvider.notifier).loginWithGoogle();
//                 },
//                 child: const Text(
//                   'Sign in with Google',
//                 ),
//               );
//             },
//           ),
//           Consumer(
//             builder: (context, ref, child) {
//               return TextButton(
//                 onPressed: () async {
//                   await ref
//                       .watch(authStateProvider.notifier)
//                       .loginWithFacebook();
//                 },
//                 child: const Text(
//                   'Sign in with Facebook',
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
