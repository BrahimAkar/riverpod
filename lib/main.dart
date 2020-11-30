import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// class IncrementNotifier extends ChangeNotifier {
//   int _value = 0;
//   int get value => _value;

//   void increment() {
//     _value++;
//     notifyListeners();
//   }
// }

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 5));
    return 'Response from $url';
  }
}

// final incrementProvider = ChangeNotifierProvider((ref) => IncrementNotifier());

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());
final responseProvider =
    FutureProvider.autoDispose.family<String, String>((ref, url) async {
  // ! AutoDispose: Dispose the state of provider
  final httpClient = ref.read(fakeHttpClientProvider);
  return httpClient.get(url);
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, watch, child) {
                final responseAsyncValue =
                    watch(responseProvider("https://youtube.com"));
                return responseAsyncValue.map(
                    data: (_) => Text(_.value),
                    loading: (_) => CircularProgressIndicator(),
                    error: (_) => Text(_.error.toString()));
              },
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   // onPressed: () => {context.read(incrementProvider).increment()},
          //   child: Icon(Icons.add),
          // ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 115),
                Center(
                  child: Text(
                    "TIKREAD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 55,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text("Your smart pocket",
                    style: TextStyle(
                      color: Colors.grey[600],
                    )),
                SizedBox(
                  height: 180,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,
                          child: FlatButton(
                            onPressed: () => {print("Button is clicked")},
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            child: Text("SIGN IN"),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 98,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dont have an account yet?",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
