import 'package:flutter/material.dart';
import 'package:peliculas_proyects/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';
import '../search/search_delegate.dart';

class HomeScreen extends StatelessWidget { 
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context , listen: true);
    //   moviesProvider.analytics.logEvent(
    //   name: 'page_created',
    //   parameters: {
    //     'page_name': 'home_screen',
    //     'area': 'logged_in_area',
    //   },
    // );
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Carteleras de Cine"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ) , 
            icon: const Icon(Icons.search_outlined))
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
           children:[
             CardSwiperShow(movies: moviesProvider.onDisplayMovies),
             MovieSlider(
               popularMovies: moviesProvider.onDisplayMovies , 
               onNextPage: () =>{
                  moviesProvider.getOnPopularMoviews()
               },
            ),
           ]
        ),
      ),
    );
  }

}