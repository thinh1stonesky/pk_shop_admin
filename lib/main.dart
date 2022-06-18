import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pk_shop_admin/SignIn.dart';
import 'package:pk_shop_admin/provider/sanpham_provider.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SanPhamProvider(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PK Shop App',
        theme: ThemeData(

          primarySwatch: Colors.grey,
        ),
        home: const SignIn(),
      ),
    );
  }
}
