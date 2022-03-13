import 'package:family_tree/providers/member_provider.dart';
import 'package:family_tree/screens/family/family_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (create) => MemberProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'Error Initializing Firebase',
              textDirection: TextDirection.ltr,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Family Tree',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MyHomePage(title: 'Family Tree'),
            );
          }
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Color.fromRGBO(28, 136, 231, 0.8),
                fixedSize: Size(200, 100),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Family(),
                  ),
                );
              },
              child: Text(
                'Member',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Color.fromRGBO(28, 136, 231, 0.8),
                fixedSize: Size(200, 100),
              ),
              onPressed: () {},
              child: Text(
                'Generation',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Color.fromRGBO(28, 136, 231, 0.8),
                fixedSize: Size(200, 100),
              ),
              onPressed: () {},
              child: Text(
                'History',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                primary: Color.fromRGBO(28, 136, 231, 0.8),
                fixedSize: Size(200, 100),
              ),
              onPressed: () {},
              child: Text(
                'Events',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
