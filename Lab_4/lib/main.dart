import 'package:flutter/material.dart';
import 'package:lab6_shopping_list/database.dart';
import 'package:lab6_shopping_list/todo_dao.dart';
import 'package:lab6_shopping_list/todo_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Shopping List/Database implementation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ListPage(database: database),
    );
  }
}

class ListPage extends StatefulWidget {
  final AppDatabase database;
  const ListPage({super.key, required this.database});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  late final ToDoDAO _dao;
  List<TodoItem> _shoppingList = [];

  @override
  void initState() {
    super.initState();
    _dao = widget.database.todoDao;
    _loadItems();               // Requirement #2: load on launch
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final items = await _dao.getAllItems();
    setState(() {
      _shoppingList = items;
    });
  }

  // Requirement #1: Add → insert into DB, then reload
  Future<void> _addItem() async {
    final itemName = _itemController.text.trim();
    final quantity = _quantityController.text.trim();

    if (itemName.isNotEmpty && quantity.isNotEmpty) {
      await _dao.insertItem(TodoItem(null, itemName, quantity));
      _itemController.clear();
      _quantityController.clear();
      await _loadItems();
    }
  }

  // Requirement #3: Long-press → confirm → delete from DB, then reload
  void _showDeleteDialog(int index) {
    final item = _shoppingList[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Do you want to delete "${item.todoItem}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await _dao.deleteItem(item);
                if (context.mounted) Navigator.of(context).pop();
                await _loadItems();
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
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: const Color(0xFFB39DDB),
                  child: const Text(
                    'Flutter Demo Home Page',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: -35,
                  child: Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    child: const Text('Click here'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _shoppingList.isEmpty
                  ? const Center(
                child: Text(
                  'There are no items in the list',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _shoppingList.length,
                itemBuilder: (context, index) {
                  final item = _shoppingList[index];
                  return GestureDetector(
                    onLongPress: () => _showDeleteDialog(index),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}: ${item.todoItem}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'quantity: ${item.todoQuantity}',
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