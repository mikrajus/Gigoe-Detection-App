import 'features/presentation/bloc/classification_bloc.dart';
import 'features/presentation/widgets/bottom_nav_bar.dart';
import 'features/presentation/bloc/img_response_bloc.dart';
import 'features/presentation/pages/add_photo_page.dart';
import 'features/presentation/bloc/data_chart_bloc.dart';
import 'features/presentation/pages/welcome_page.dart';
import 'features/presentation/pages/splash_page.dart';
import 'features/presentation/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await di.setup();

  runApp(const MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   print('=== INITIALIZING FIREBASE ===');
//   try {
//     await Firebase.initializeApp();
//     print('Firebase initialized successfully!');
//     print('Firebase App Name: ${Firebase.app().name}');
//     print('Firebase Options: ${Firebase.app().options}');
//   } catch (e) {
//     print('Firebase initialization ERROR: $e');
//   }

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//   await di.setup();
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<ClassificationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ImgResponseBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DataChartBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        // initialRoute: '/main', // <-- Tambahkan baris ini
        routes: {
          '/': (context) => const SplashPage(),
          '/welcome': (context) => const WelcomePage(),
          '/main': (context) => const MyHomePage(),
          '/login_page': (context) => const LoginPage(),
          '/add_photo': (context) => const AddPhoto(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const BottomNavBar();
  }
}
