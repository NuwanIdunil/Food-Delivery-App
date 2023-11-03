import '../mainScreens/item.dart';

class ShoppingCart {
  List<Item> items = [];

  void addItem(Item item) {
    // Check if the item is already in the cart
    if (!items.contains(item)) {
      items.add(item);
    }
  }

  void removeItem(Item item) {
    items.remove(item);
  }

  double getTotalPrice() {
    double total = 0.0;
    double totalForItem=0.0;
    for (var item in items) {

      total += (item.price*item.quantity);
    }
    return total;
  }

  void incrementQuantity(Item item) {
    final index = items.indexOf(item);
    if (index != -1) {
      items[index].quantity++;
    }
  }

  // Add a method to decrement the quantity of an item
  void decrementQuantity(Item item) {
    final index = items.indexOf(item);
    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      }
    }
  }

}
