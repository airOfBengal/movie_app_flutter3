import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MoviesApp(),
  );
}

const apiKey = 'cc8942c6102814ef3cf422a176301229';

class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviesListing(),
    );
  }
}

class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  @override
  State<MoviesListing> createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  List<MovieModel> movies = <MovieModel>[];

  fetchMovies() async {
    var data = await MoviesProvider.getJson();
    setState(() {
      List<dynamic> results = data['results'];
      results.forEach((element) {
        movies.add(MovieModel.fromJson(element));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: ListView.builder(
        itemCount: movies == null ? 0 : movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: MovieTile(movies, index),
          );
        },
      ),
    );
  }
}

class MoviesProvider {
  static final String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

  static Future<Map> getJson() async {
    const apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=popularity.desc";
    final apiResponse = await http.get(apiEndPoint);
    return json.decode(apiResponse.body);
  }
}

class MovieModel {
  //Class fields for mapping to JSON properties
  final int id;
  final num popularity;
  final int vote_count;
  final bool video;
  final String poster_path;
  final String backdrop_path;
  final bool adult;
  final String original_language;
  final String original_title;
  final List<dynamic> genre_ids;
  final String title;
  final num vote_average;
  final String overview;
  final String release_date;

  //Takes JSON formatted map, and returns `MovieModel` object.
  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        popularity = json['popularity'],
        vote_count = json['vote_count'],
        video = json['video'],
        poster_path = json['poster_path'],
        adult = json['adult'],
        original_language = json['original_language'],
        original_title = json['original_title'],
        genre_ids = json['genre_ids'],
        title = json['title'],
        vote_average = json['vote_average'],
        overview = json['overview'],
        release_date = json['release_date'],
        backdrop_path = json['backdrop_path'];
}

class MovieTile extends StatelessWidget {
  final List<MovieModel> movies;
  final index;

  const MovieTile(this.movies, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          movies[index].poster_path != null
              ? Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(MoviesProvider.imagePathPrefix +
                          movies[index].poster_path),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        offset: Offset(1, 3),
                      ),
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              movies[index].title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              movies[index].overview,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}
