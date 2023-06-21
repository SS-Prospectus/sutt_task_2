import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Storage and API/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieScreen extends ConsumerStatefulWidget {
  const MovieScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ..._buildBackground(context, widget.movie),
          _buildMovieInformation(context, widget.movie),
          _buildActions(context, widget.movie),
        ],
      ),
    );
  }
  bool isExpanded = false;

  Positioned _buildActions(BuildContext context, Movie movie) {
    return Positioned(
      bottom: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                backgroundColor: const Color(0xFFF8D848),
                fixedSize: Size(MediaQuery.of(context).size.width * 0.425, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                addToLikedMovies(movie,ref);
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Add to ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: 'Liked',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                primary: Colors.white,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.425, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                String youtubeTrailerKey = movie.videoPath; // Replace with your YouTube trailer key

                final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$youtubeTrailerKey');

                launchUrl(youtubeUrl);
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'Watch ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'Trailer',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildMovieInformation(BuildContext context, Movie movie) {

    return Positioned(
      bottom: 150,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              movie.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${movie.year} | ${movie.category} | ${movie.duration.inHours}h ${movie.duration.inMinutes.remainder(60)}m',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: double.parse(movie.rating)/2,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 20,
              unratedColor: Colors.white,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(height: 10),
            Text(
              movie.tagline,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                movie.description,
                overflow: TextOverflow.ellipsis,
                maxLines: isExpanded ? 9 : 4,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(height: 1.75, color: Colors.white),
              ),
              trailing: Icon(Icons.expand_more),
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackground(context, movie) {
    return [
      Container(
        height: double.infinity,
        color: const Color(0xFF30181B),
      ),
      Image.network(
        movie.imagePath,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        fit: BoxFit.cover,
      ),
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF20180B),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.5],
            ),
          ),
        ),
      ),
    ];
  }
}

