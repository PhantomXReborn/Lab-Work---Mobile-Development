
import 'package:flutter_test/flutter_test.dart';

import 'package:lab6_shopping_list/main.dart';
import 'package:lab6_shopping_list/database.dart';

void main() {
  testWidgets('Shopping list app loads successfully',
          (WidgetTester tester) async {

        // Create an in-memory database for testing
        final database =
        await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

        // Close the database after the test
        addTearDown(() async {
          await database.close();
        });

        // Launch the application with the database
        await tester.pumpWidget(MyApp(database: database));

        // Verify that the application loads
        expect(find.byType(MyApp), findsOneWidget);
      });
}
