class Movie {
  final String description;
  final String rating;
  final String name;
  final String imagePath;
  final String videoPath;
  final String category;
  final String year;
  final Duration duration;
  final String tagline;
  final String? movieid;

  const Movie({
    required this.description,
    required this.rating,
    required this.name,
    required this.imagePath,
    required this.videoPath,
    required this.category,
    required this.year,
    required this.duration,
    required this.tagline,
    this.movieid,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'rating': rating,
      'name': name,
      'imagePath': imagePath,
      'videoPath': videoPath,
      'category': category,
      'year': year,
      'duration': duration.inMilliseconds,
      'tagline': tagline,
      'movieid': movieid,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      description: json['description'] as String,
      rating: json['rating'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      videoPath: json['videoPath'] as String,
      category: json['category'] as String,
      year: json['year'] as String,
      duration: Duration(milliseconds: json['duration'] as int),
      tagline: json['tagline'] as String,
      movieid: json['movieid'] as String?,
    );
  }
}

class Premovie {
  final String title;
  final String movieid;
  final int? year;

  const Premovie({
    required this.title,
    required this.movieid,
    required this.year,
});
}

