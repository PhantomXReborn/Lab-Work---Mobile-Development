import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 - Shopping List',
      debugShowCheckedModeBanner: false, // We create a custom ribbon to match the screenshot
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // Controllers for the text fields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // List to hold the shopping items
  final List<Map<String, String>> _shoppingList = [];

  // 1. Function to add an item
  void _addItem() {
    String itemName = _itemController.text.trim();
    String quantity = _quantityController.text.trim();

    if (itemName.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        _shoppingList.add({'name': itemName, 'quantity': quantity});
      });

      // 2. Clear the TextFields after inserting
      _itemController.clear();
      _quantityController.clear();
    }
  }

  // 3. Function to show AlertDialog on Long-Press
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Do you want to delete "${_shoppingList[index]['name']}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // 5. Selecting "No" does not remove the item
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // 4. Selecting "Yes" removes the item
                setState(() {
                  _shoppingList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header matching the screenshot
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: const Color(0xFFB39DDB), // Light purple color
                  child: const Text(
                    'Flutter Demo Home Page',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Custom Debug Ribbon
                Positioned(
                  top: 15,
                  right: -35,
                  child: Transform.rotate(
                    angle: 0.785398, // 45 degrees in radians
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                      color: Colors.red[800],
                      child: const Text(
                        'DEBUG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Input Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        hintText: 'Type the item here',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Type the quantity here',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text('Click here'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // List Area
            Expanded(
              child: _shoppingList.isEmpty
              // Text showing when list is empty
                  ? const Center(
                child: Text(
                  'There are no items in the list',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              // ListView to display items
                  : ListView.builder(
                itemCount: _shoppingList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _showDeleteDialog(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Number and item name
                          Text(
                            '${index + 1}: ${_shoppingList[index]['name']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          // Quantity to the right
                          Text(
                            'quantity: ${_shoppingList[index]['quantity']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}