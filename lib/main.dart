import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/category_meals_screen.dart';
import 'package:meals_app/screens/filter_screen.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';
import 'package:meals_app/screens/tabs_screen.dart';
import 'package:meals_app/widgets/dummy_data.dart';

import 'models/meals.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    "gluten" : false,
    "lactose": false,
    "vegan": false,
    "vegetarian": false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String, bool> filterData){
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal){
        if(_filters["gluten"] == true && !meal.isGlutenFree){
          return false;
        }
        if(_filters["lactose"] == true && !meal.isLactoseFree){
          return false;
        }
        if(_filters["vegan"] == true && !meal.isGlutenFree){
          return false;
        }
        if(_filters["vegetarian"] == true && !meal.isGlutenFree){
          return false;
        }
        return true;

      }).toList();
    });
  }

  void _toggleFavorites(String mealID){
    final existingIndex = _favouriteMeals.indexWhere((test) => test.id == mealID);
    if(existingIndex >= 0){
     setState(() {
       _favouriteMeals.removeAt(existingIndex);
     });
    }
    else{
      setState(() {
        _favouriteMeals.add(DUMMY_MEALS.firstWhere((element) => element.id == mealID));
      });
    }
  }

  bool _isMealFavourite(String id){
    return _favouriteMeals.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Meals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: "Raleway",
        textTheme: ThemeData.light().textTheme.copyWith(
              bodySmall: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyLarge: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              titleMedium:
                  TextStyle(fontSize: 20, fontFamily: "RobotoCondensed", fontWeight: FontWeight.bold),
            ),
      ),
      //home: CategoriesScreen(),
      // initialRoute: "/",
      routes: {
        "/": (ctx) => TabsScreen(_favouriteMeals),
        // "/category-meals" : (ctx) => CategoryMealsScreen(),
        FiltersScreen.routeName : (ctx) => FiltersScreen(_filters,_setFilters),
        CategoryMealsScreen.routeName : (ctx) => CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName : (ctx) => MealDetailScreen(_toggleFavorites, _isMealFavourite),
      },

      onGenerateRoute: (settings){
        print(settings.arguments);
        // if(settings.name == "/meal-detail"){
        //   return ...;
        // }
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },

     //404 Error in Web (To provide Fault Taulerance as in Web page Not found error msg in Web)
      onUnknownRoute:(settings){
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
     } ,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Daily Meals"),
//       ),
//       body: Center(
//         child: Text("Navigation Time!"),
//       ),
//     );
//   }
// }
