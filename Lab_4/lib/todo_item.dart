
import 'package:floor_community/floor.dart';

@entity
class TodoItem {
  @primaryKey
  final int? id;

  final String todoItem;
  final String todoQuantity;

  TodoItem(this.id, this.todoItem, this.todoQuantity);
}
