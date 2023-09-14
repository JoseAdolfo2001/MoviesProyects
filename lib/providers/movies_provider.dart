
import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_proyects/models/models.dart';
import '../debouncer.dart';

class MoviesProvider extends ChangeNotifier{
  final BuildContext context;
  List <Movie> onDisplayMovies = [];
  List <Movie> onPopularDisplayMovies = [];
  String title = "";
  String message = "";
  //FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Map< int , List<Cast>> movieCast = {}; 
  int _pageCounter = 0;

  final debouncer = Debouncer(
    duration: const Duration( milliseconds: 500 ),
  );

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

   Future _backgroundHandler(RemoteMessage message) async {
    title = message.notification?.title ?? "Generic title";
    title = message.notification?.body ?? "Generic body";
  }

   Future _onMessageHandler(RemoteMessage message) async {
    title = message.notification?.title ?? "Generic title";
    title = message.notification?.body ?? "Generic body";
  }

   Future _onMessageOpenApp(RemoteMessage message) async {
    title = message.notification?.title ?? "Generic title";
    title = message.notification?.body ?? "Generic body";
  
  }

  Future initializeApp() async {

         await Firebase.initializeApp();
         token = await FirebaseMessaging.instance.getToken();
         print("$token soy el token de firebase");

         FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
         FirebaseMessaging.onMessage.listen(_onMessageHandler);
         FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  final StreamController<List<Movie>> _suggestionStreamContoller =  StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamContoller.stream;

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'd4e072f8892d7cd89115f8b7a10f41de';
  final String _languaje = 'es-Es';

  MoviesProvider(this.context){
    print('MoviesProvider inicializando');

    getOnDisplayMovies();
    initializeApp();
    getOnPopularMoviews();
  }

  Future<String> _getJsonData( String endpoint , [int page = 1] )async {
      var url = Uri.https(_baseUrl , endpoint , {
      'api_key': _apiKey,
      'languaje': _languaje,
      'page': "$page"
    });
     final response = await http.get(url);
     return response.body;
  }

  getOnDisplayMovies() async {;
  final jsonResponse = await _getJsonData('3/movie/now_playing');
  final jsonDecodeNow= jsonDecode(jsonResponse);
  final nowPlayingResponse = NowPlayingResponse.fromJson(jsonDecodeNow);
  onDisplayMovies = nowPlayingResponse.results;
  notifyListeners();

  }

  getOnPopularMoviews() async{
  _pageCounter++;
  final jsonResponse = await _getJsonData('3/movie/popular' , _pageCounter);
  final jsonDecodePoular = jsonDecode(jsonResponse);
  final popularMoviesResponse = PopularMoviesResponse.fromJson(jsonDecodePoular);
  onPopularDisplayMovies = [...onPopularDisplayMovies, ...popularMoviesResponse.results];
  notifyListeners();  
  }

  Future <List<Cast>> getMovieCast  ( int movieId) async {

    if(movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonResponse = await _getJsonData('3/movie/$movieId/credits');
    final jsonDecodeCredits = jsonDecode(jsonResponse);
    final creditsResponse = CreditResponse.fromJson(jsonDecodeCredits);
    movieCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

    Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _languaje,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      _suggestionStreamContoller.add( results );
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }

  void showNotificationDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Acción cuando se presiona el botón del diálogo
              Navigator.pop(context);
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

 void handlePushNotification(Map<String, dynamic> message) {
    // Extraer los datos necesarios de la notificación push
    final notificationTitle = message['notification']['title'];
    final notificationBody = message['notification']['body'];

    // Mostrar el diálogo personalizado
    showNotificationDialog(notificationTitle, notificationBody);
  }


}