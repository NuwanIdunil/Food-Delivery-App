import 'package:flutter/material.dart';
import '../mainScreens/item.dart';
import 'cart.dart';

 // Import your Item class here

class ShoppingCartPage extends StatefulWidget {
  final ShoppingCart shoppingCart;

  ShoppingCartPage({required this.shoppingCart});

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: ListView.builder(
        itemCount: widget.shoppingCart.items.length,
        itemBuilder: (context, index) {
          Item item = widget.shoppingCart.items[index];
          return ListTile(
            title: Column(
                children:[
                  Image.network(item.image,cacheHeight:100,cacheWidth: 100,),
                  Text(item.name),
                  Text("Rs. ${item.price.toStringAsFixed(2)}"),],),



            trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  // Decrement the quantity of the item
                  setState(() {
                    widget.shoppingCart.decrementQuantity(item);
                  });
                },
              ),
              Text(item.quantity.toString()), // Display the quantity
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Increment the quantity of the item
                  setState(() {
                    widget.shoppingCart.incrementQuantity(item);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remove the item from the shopping cart
                  setState(() {
                    widget.shoppingCart.removeItem(item);
                  });
                },
              ),
            ],
          ),
          );
        },
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total: Rs. ${widget.shoppingCart.getTotalPrice().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              ElevatedButton(
                onPressed: () {
                  // Implement the logic to complete the purchase here
                },
                child: Text("Checkout"),
              ),
            ],
          ),
        ),

    );
  }
}
