import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/login_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/food/food_bloc.dart';
import 'bloc/food/food_event.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/favorites/favorites_bloc.dart';

void main() {
  runApp(const FoodieExpressApp());
}

class FoodieExpressApp extends StatelessWidget {
  const FoodieExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => FoodBloc()..add(LoadFoodItems())),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => FavoritesBloc()),
      ],
      child: MaterialApp(
        title: 'FoodieExpress',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
