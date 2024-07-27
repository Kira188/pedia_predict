// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pedia/home_page.dart';
// import 'package:pedia/auth/login_page.dart';
// import 'package:pedia/utils/database_helper.dart';
// import 'package:pedia/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final DatabaseHelper dbHelper = DatabaseHelper();

//     return MaterialApp(
//       title: 'Pedia Predict',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthWrapper(dbHelper: dbHelper),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   final DatabaseHelper dbHelper;

//   const AuthWrapper({super.key, required this.dbHelper});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           User? user = snapshot.data;
//           if (user == null) {
//             return LoginPage(dbHelper: dbHelper);
//           } else {
//             return HomePage(dbHelper: dbHelper);
//           }
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:pedia/image_question.dart';
// import 'package:pedia/psss/psss_habits.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pedia Predict',
//       theme: ThemeData(
//       ),
//       home: const ImageQuestion(), // You can change the habitType here
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedia_predict/home_page.dart';
import 'package:pedia_predict/auth/auth_page.dart';
import 'package:pedia_predict/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedia Predict',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint("AuthWrapper: Connection state - ${snapshot.connectionState}");
        debugPrint("AuthWrapper: User - ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthPage();
          } else {
            return const HomePage();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}