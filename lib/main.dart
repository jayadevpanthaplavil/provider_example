// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class CounterProvider extends ChangeNotifier {
//   int _count = 0;
//
//   int get getCountValue => _count;
//
//   void incrementCounter() {
//     _count++;
//     notifyListeners();
//   }
//
//   void decrementCounter() {
//     _count--;
//     notifyListeners();
//   }
//
//   void resetCounter() {
//     _count = 0;
//     notifyListeners();
//   }
// }
//
// void main() {
//   runApp(MultiProvider(child: MyApp(),
//       providers: [
//         ChangeNotifierProvider(create: (context) => CounterProvider()),
//
//       ]));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CounterScreen(),
//     );
//   }
// }
//
// class CounterScreen extends StatefulWidget {
//   const CounterScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CounterScreen> createState() => _CounterScreenState();
// }
//
// class _CounterScreenState extends State<CounterScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     final _provider=Provider.of<CounterProvider>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text("Counter using Provider"),),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: Consumer<CounterProvider>(
//                 builder: (context, value, child) {
//                   return Text("${_provider._count}",//value.getCountValue.toString(),
//                     style: TextStyle(fontSize: 40),);
//                 },
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(onPressed: () {
//                   _provider.incrementCounter();
//                   //context.read<CounterProvider>().incrementCounter();
//                 }, child: Text("Increment")),
//                 ElevatedButton(onPressed: () {
//                   context.read<CounterProvider>().decrementCounter();
//
//                 }, child: Text("Decrement")),
//                 ElevatedButton(onPressed: () {
//                   context.read<CounterProvider>().resetCounter();
//                 }, child: Text("Reset"))
//               ],
//             )
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: (){
//       //     context.read<CounterProvider>().incrementCounter();
//       //   },
//       //   child: Icon(Icons.add),
//       // ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Products.dart';
import 'package:http/http.dart' as http;

import 'ProductsJson.dart';

class ApiService {
  Future<List<Products>?> fetchProducts() async {
    final response =
        await http.get(Uri.parse("https://dummyjson.com/products"));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body.toString());
      var data = ProductsJson.fromJson(jsonString);
      var listProducts = data.products;
      //print(response.statusCode);
      return listProducts;
    } else {
      throw Exception("Failed to load");
    }
  }
}

class ProductsProvider with ChangeNotifier {
  List<Products> _plist = [];

  get plist => _plist;

  ApiService api = ApiService();

  Future<void> fetch() async {
    _plist = (await api.fetchProducts())!;
    notifyListeners();
  }
}

void main() {
  runApp(MultiProvider(child: MyApp(), providers: [
    ChangeNotifierProvider(create: (context) => ProductsProvider())
  ]));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductsProvider>(context);
    _provider.fetch();
    final List<Products> prolist = _provider.plist;
    return Scaffold(
      body: ListView.builder(
          itemCount: prolist.length,
          itemBuilder: (BuildContext context, int index) {
            Products pro = prolist[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.network("${pro.thumbnail}"),
                    ),
                    Text("${pro.description}"),
                    // Row(
                    //   children: [
                    //     Text("Status  - "),
                    //     Container(child: us.completed==true ? Icon(Icons.done): Icon(Icons.error)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
