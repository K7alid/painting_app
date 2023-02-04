import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:painting_app/customers_screen/customers_screen.dart';

import 'firebase_options.dart';
import 'login_screen/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/cache_helper.dart';

String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Widget widget;
  token = CacheHelper.getData(key: 'token');
  if (token != null) {
    widget = CustomersScreen();
  } else {
    widget = LoginScreen();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        primarySwatch: Colors.cyan,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(foregroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: startWidget,
    );
  }
}
