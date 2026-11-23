
import 'package:floor_community/floor.dart';
import 'todo_item.dart';

@dao
abstract class ToDoDAO {

  // Get all shopping list items
  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> getAllItems();

  // Insert a new shopping list item
  @insert
  Future<void> insertItem(TodoItem item);

  // Delete a shopping list item
  @delete
  Future<void> deleteItem(TodoItem item);
}
