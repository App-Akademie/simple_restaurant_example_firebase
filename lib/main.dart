import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_restaurant_example_firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String result = "";
  List<String> restaurantNames = [];

  @override
  void initState() {
    super.initState();
    getRestaurantLength();
    getAllRestaurants();
  }

  void getRestaurantLength() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    final CollectionReference<Map<String, dynamic>> restaurantReference =
        instance.collection("restaurants");
    final QuerySnapshot<Map<String, dynamic>> restaurantSnapshot =
        await restaurantReference.get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> restaurants =
        restaurantSnapshot.docs;

    final int numberOfRestaurants = restaurants.length;
    result = "Number of Restaurants: $numberOfRestaurants";
    setState(() {});

    // instance.collection("restaurants").get().then(
    //   (restaurants) {
    //     final int numberOfRestaurants = restaurants.docs.length;
    //     result = "Restaurant length: $numberOfRestaurants";
    //     setState(() {});
    //   },
    // );
  }

  void getAllRestaurants() {
    FirebaseFirestore instance = FirebaseFirestore.instance;

    instance.collection("restaurants").get().then(
      (currentSnapshot) {
        List<String> names = [];

        for (final doc in currentSnapshot.docs) {
          final Map<String, dynamic> data = doc.data();
          final String restaurantName = data["name"];
          print(restaurantName);
          names.add(restaurantName);
        }

        restaurantNames = names;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 4.2,
          title: const Text(
            "Simple Restaurant App 🔥base",
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                style: const TextStyle(fontSize: 24),
                result,
              ),
              const SizedBox(height: 64),
              const Text(
                style: TextStyle(fontSize: 24),
                "Restaurant Names:",
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: restaurantNames.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        textAlign: TextAlign.center,
                        restaurantNames[index],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
