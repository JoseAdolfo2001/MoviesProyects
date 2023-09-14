import 'package:flutter/material.dart';
import 'package:peliculas_proyects/providers/movies_provider.dart';
import 'package:peliculas_proyects/screens/prueba_screens.dart';
import 'package:peliculas_proyects/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState  extends StatelessWidget {
  const AppState({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: ( _ ) => MoviesProvider(context) ,  lazy: false,), 
      ],
      child:const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Peliculas",
      initialRoute: 'home',
      routes: {
        'home' : ( _) => const HomeScreen(),
        'details' : (_) => const DetailsScreen(),
        'helloword' : (_) => const HelloWord(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo
        )
      ),
    );
  }
  } 