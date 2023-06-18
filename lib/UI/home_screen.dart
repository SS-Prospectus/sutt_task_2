import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/movie_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_task_2/Models/model.dart';
import 'package:sutt_task_2/UI/fadeanimation.dart';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/Storage and API/api_services.dart';
import 'package:riverpod/riverpod.dart';


enum FormData {
  search
}

List<Movie> currentlist = Movie.movies;

class HomePage extends ConsumerStatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Color enabled = Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  FormData? selected;


  TextEditingController inputController = TextEditingController();


  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userprovider);
    final name = userProvider.username;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF000B49),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    'Hello ' + name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await UserSecureStorage.setLoggedIn('false');
                    context.go('/login');
                  },
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: FadeAnimation(
          delay: 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF000B49),
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.title,
                                color: selected == FormData.search
                                    ? enabledtxt
                                    : deaible,
                                size: 20,
                              ),
                              hintText: 'Search for movies',
                              hintStyle: TextStyle(
                                  color: selected == FormData.search
                                      ? enabledtxt
                                      : deaible,
                                  fontSize: 20),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                color: selected == FormData.search
                                    ? enabledtxt
                                    : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async{
                            String searchQuery = inputController.text;
                            List<Movie> searchedmovies = await fetchMoviesByTitle(searchQuery);
                            setState(() {
                              currentlist = searchedmovies;
                            });
                          },
                          child: Text('Search'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleLarge,
                            children: [
                              TextSpan(
                                text: currentlist == Movie.movies ? 'Liked ': 'Searched ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: 'Movies',
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: currentlist != Movie.movies,
                          child: GestureDetector(
                            child: Text(
                              'Liked Movies',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                currentlist = Movie.movies;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (final movie in currentlist)
                      InkWell(
                        onTap: () {
                          context.pushNamed('info', extra:movie );
                        },
                        child: MovieListItem(
                          imageUrl: movie.imagePath,
                          name: movie.name,
                          information:
                          '${movie.year} | ${movie.category} | ${movie.duration.inHours}h ${movie.duration.inMinutes.remainder(60)}m',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}