import 'package:flutter/material.dart';
import 'package:peliculas_proyects/widgets/widgets.dart';
import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return  Scaffold(
      body: CustomScrollView(
        slivers: [
           _CustomAppbar(movie: movie,),
          SliverList(
            delegate: SliverChildListDelegate([
               _PosterAndTitle(movie:movie),
               _Overview(movie: movie),
               _Overview(movie: movie),
               _Overview(movie: movie),
               CastingCards(movieId: movie.id),
            ] 
            ),
          )
        ],
      )
    );
  }
}

class _CustomAppbar extends StatelessWidget {
  final Movie movie ;
  const _CustomAppbar({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return   SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          color:Colors.black12,
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10 , left: 10 , right: 10),
          child:  Text(movie.title , style: const TextStyle(fontSize: 20),textAlign: TextAlign.center,),
        ),
        background:  FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdrotPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  
  const _PosterAndTitle({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top:20),
      padding: const  EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage( movie.fullPosterImg ),
                height: 150,
              ),
            ),
          ),

          const SizedBox(width:20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              children: [
                  Text(
                    movie.title , 
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                Text(
                  movie.originalTitle , 
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
          
                Row(
                  children: [
                    const Icon(Icons.star_outline , size: 15,color: Colors.grey),
                    const SizedBox(width: 5,),
                    Text('${movie.voteAverage}' , style: Theme.of(context).textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 10),
      child: Text(movie.overview , 
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}