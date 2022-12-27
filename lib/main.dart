import 'package:auth_with_firebase_emulator/firebase_options.dart';
import 'package:auth_with_firebase_emulator/objects/entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      print(e);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String email = 'htahta103@gmail.com';
  late String pass = '123456';

  late String title = 'htahta103@gmail.com';
  late String text = 'text content';
  @override
  void initState() {
    super.initState();
  }

  Future<String> login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      return 'success';
    } catch (e) {
      return 'false';
    }
  }

  Future<String> writeEntrieToFirebase(Entry entry) async {
    try {
      await FirebaseFirestore.instance
          .collection('Entries')
          .add(<String, dynamic>{
        'title': entry.title,
        'text': entry.text,
      });
      return 'write success';
    } catch (e) {
      return 'failed to write: $e';
    }
  }

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
            ...loginSection(),
            const SizedBox(
              height: 100,
            ),
            ...writeEntrySection()
          ],
        ),
      ),
    );
  }

  List<Widget> loginSection() {
    return [
      const Text(
        'Firebase Login Emulator',
      ),
      TextFormField(
        initialValue: email,
        decoration: const InputDecoration(
          hintText: 'email',
        ),
        onChanged: (value) {
          email = value;
          setState(() {});
        },
      ),
      TextFormField(
        initialValue: pass,
        decoration: const InputDecoration(
          hintText: 'pass',
        ),
        onChanged: (value) {
          pass = value;
          setState(() {});
        },
      ),
      ElevatedButton(
        onPressed: () async {
          var res = await login();
          showSnackBar(context, res);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Text('Sign In'),
        ),
      ),
    ];
  }

  List<Widget> writeEntrySection() {
    return [
      const Text(
        'Firebase Login Emulator',
      ),
      TextFormField(
        initialValue: title,
        decoration: const InputDecoration(
          hintText: 'title',
        ),
        onChanged: (value) {
          title = value;
          setState(() {});
        },
      ),
      TextFormField(
        initialValue: text,
        decoration: const InputDecoration(
          hintText: 'text',
        ),
        onChanged: (value) {
          text = value;
          setState(() {});
        },
      ),
      ElevatedButton(
        onPressed: () async {
          var res = await writeEntrieToFirebase(Entry(title, text));
          showSnackBar(context, res);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Text('Write Entry'),
        ),
      ),
    ];
  }
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
