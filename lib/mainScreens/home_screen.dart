import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfood/cart_model/cart.dart';
import '../cart_model/shppingcart.dart';
import '../profile/profile.dart';
import 'item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item>basketItem = [];
  final ShoppingCart shoppingCart = ShoppingCart();
  int _currentIndex = 0;


  void onTabTapped(int index) {
    if (index == 1) { // Check if the "Cart" button is tapped (index 1)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShoppingCartPage(shoppingCart: shoppingCart),
        ),
      );}
     else if  (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }
     else {
      setState(() {
        _currentIndex = index;
      });
    }
  }
  @override
  void initState() {
    fetchRecords();
    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection("food").get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>>records) {
    var _list = records.docs.map(
          (item) =>
          Item(
            id: item.id,
            name: item['name'],
            price: item['price'],
            image: item['image'],
          ),
    ).toList();
    setState(() {
      basketItem = _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          ),
        ),

        title:const Text("N Food",
          style: TextStyle(
            fontSize: 40,
            color:Color(0xFF0A0348),
            fontFamily: "Signatra",
          ),),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: (basketItem.length / 2).ceil(),
        itemBuilder: (context, rowIndex) {
          final startIndex = rowIndex * 2;
          final endIndex = startIndex + 2 <= basketItem.length
              ? startIndex + 2
              : basketItem.length;

          return Row(
            children: List.generate(endIndex-startIndex, (index) {
              final itemIndex = startIndex + index;
              return Expanded(
                child: Card(
                  elevation: 8.0,
                  borderOnForeground: false,
                  color: Colors.white,
                  shadowColor: Colors.black,
                  surfaceTintColor: Colors.white,
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Column(
                  children: [
                  Image.network(basketItem[itemIndex].image,cacheHeight:200,cacheWidth: 300,),
                  Text(basketItem[itemIndex].name, style: TextStyle(
                    fontSize: 18,
                    color:Colors.indigo.withOpacity(0.6),
                    fontFamily: "Bebas",
                  )),
                    Text("Rs. "+basketItem[itemIndex].price.toString()+".00",
                        style: const TextStyle(
                          fontSize: 15,
                          color:Color(0xFF0A0348),
                          fontFamily: "Bebas",
                        )),
                    ElevatedButton(
                      onPressed: () {
                        // Add the item to the shopping cart
                        shoppingCart.addItem(basketItem[itemIndex]);
                        // You can also display a snackbar or a toast to confirm the item was added
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item added to cart'),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShoppingCartPage(shoppingCart: shoppingCart),
                          ),
                        );
                      },
                      child: const Text("Add TO Cart", style: TextStyle(color: Colors.blue),),
                    )
                  ],
                ),

                     // Display the image
                  ),
                ),
              );
            }),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

