import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> popularMovies;
  final Function onNextPage;
  const MovieSlider({super.key, required this.popularMovies, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController =  ScrollController();

  @override
  void initState() {
super.initState();
    scrollController.addListener(() { 
        if(scrollController.position.pixels >= scrollController.position.maxScrollExtent -  500){
            widget.onNextPage();
        }
    });

  }

  @override
  void dispose() {

    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: 
              Text('Populares' , style: TextStyle(fontSize: 20 , fontWeight:FontWeight.bold ),)
            ),

            Expanded(
              child: ListView.builder(
                controller:scrollController ,
                scrollDirection: Axis.horizontal,
                itemCount: widget.popularMovies.length,
                itemBuilder: ( _ , int index) => _MoviePoster(popularMovies: widget.popularMovies[index] , heroId: '${ widget.popularMovies[index].title }-$index-${ widget.popularMovies[index].id }')
              ),
           ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie popularMovies;
  final String heroId;
  const _MoviePoster({
    super.key, required this.popularMovies, required this.heroId
  });

  @override
  Widget build(BuildContext context) {
    popularMovies.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
      child: Column(
        children:[
           GestureDetector(
             onTap: () => Navigator.pushNamed(context, 'details' , arguments: popularMovies),
             child: Hero(
               tag: popularMovies.heroId!,
               child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                 child: FadeInImage(
                  placeholder: const  AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(popularMovies.fullPosterImg),
                  width: 130,
                  height: 180,
                  fit: BoxFit.cover,
                  ),
               ),
             ),
           ),
            
            const SizedBox(height: 5),

            Text(popularMovies.title, maxLines: 1 , overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}