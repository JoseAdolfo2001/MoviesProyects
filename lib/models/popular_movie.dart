
import 'dart:convert';
import 'models.dart';

class PopularMoviesResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    PopularMoviesResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory PopularMoviesResponse.fromRawJson(String str) => PopularMoviesResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PopularMoviesResponse.fromJson(Map<String, dynamic> json) => PopularMoviesResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}
