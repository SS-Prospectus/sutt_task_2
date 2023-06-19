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
}