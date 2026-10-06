import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Index',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const RecipeIndexPage(),
    );
  }
}

class RecipeIndexPage extends StatelessWidget {
  const RecipeIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 32),

              // Row 1 - Title (centered)
              const Text(
                'RECIPE INDEX',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),

              // Row 2 - Subtitle (left aligned)
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Find the perfect recipe for any occasion',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Row 3 - "By Course" (centered)
              const Text(
                'By Course',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              // Row 4 - By Course image row (SpaceAround, text in middle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleImageWithText(
                    imagePath: 'assets/images/beef.jpg',
                    label: 'Beef',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/chicken.jpg',
                    label: 'Chicken',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/pork.jpg',
                    label: 'Pork',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/seafood.jpg',
                    label: 'Seafood',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Row 5 - "By Dish" (centered)
              const Text(
                'By Dish',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              // Row 6 - By Dish image row (SpaceAround, text at bottom)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleImageWithText(
                    imagePath: 'assets/images/main_dishes.jpg',
                    label: 'Main dishes',
                    textAtBottom: true,
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/salad.jpg',
                    label: 'Salad Recipes',
                    textAtBottom: true,
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/side_dishes.jpg',
                    label: 'Side Dishes',
                    textAtBottom: true,
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/crockpot.jpg',
                    label: 'Crockpot',
                    textAtBottom: true,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Row 7 - "By Dessert" (centered)
              const Text(
                'By Dessert',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              // Row 8 - By Dessert image row (SpaceAround, text in middle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleImageWithText(
                    imagePath: 'assets/images/ice_cream.jpg',
                    label: 'Ice Cream',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/brownies.jpg',
                    label: 'Brownies',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/pies.jpg',
                    label: 'Pies',
                  ),
                  CircleImageWithText(
                    imagePath: 'assets/images/cookies.jpg',
                    label: 'Cookies',
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable widget: circular image with a text label overlaid via Stack.
/// If [textAtBottom] is true the label sits at the bottom-center of the
/// circle; otherwise it sits in the middle.
class CircleImageWithText extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool textAtBottom;

  const CircleImageWithText({
    super.key,
    required this.imagePath,
    required this.label,
    this.textAtBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment:
      textAtBottom ? Alignment.bottomCenter : Alignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 55,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}