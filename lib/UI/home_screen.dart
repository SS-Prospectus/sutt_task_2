import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_task_2/Logic/movie_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_task_2/UI/fadeanimation.dart';
import 'package:sutt_task_2/Storage and API/secure_storage.dart';
import 'package:sutt_task_2/Logic/userprovider.dart';
import 'package:sutt_task_2/Storage and API/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'showSnackbar.dart';


enum FormData {
  search
}

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
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showSnackBar(context, 'Double Tap to like or dislike');
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userprovider);
    final name = userProvider.username;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF03040A),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('lib/assets/Backgroundhome.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          ),
          SafeArea(
            child: SingleChildScrollView(
            child: FadeAnimation(
              delay: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello ',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              name,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF20180B),
                                ),
                                child: TextField(
                                  controller: inputController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
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
                                            ? Color(0xFFC0C0C0)
                                            : Colors.white,
                                        fontSize: 16),
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
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xEFF8D848)),
                              ),
                              onPressed: () async{
                                ref.watch(searchqueryProvider.notifier).update((state) => inputController.text);;
                              },
                              child: Text('Search',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.titleLarge,
                                children: [
                                  TextSpan(
                                    text: ref.watch(searchqueryProvider) == "" ? 'Liked ': 'Searched ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold, color:Color(0xFFF8D848) ),
                                  ),
                                  const TextSpan(
                                    text: 'Movies',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: ref.watch(searchqueryProvider) != "",
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF20180B),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(
                                    'Liked Movies',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  ref.read(searchqueryProvider.notifier).update((state) => "");
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ref.watch(fetchmovieProvider(ref.watch(searchqueryProvider))).when(
                            data: (data) {
                              if (data == null || data.isEmpty) {
                                return Center(
                                    child: 
                                    Text('No movies found.'));
                              }
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref.read(currentlistProvider.notifier).update((state) => data);
                              });
                              return Column(
                                children: [
                                  for (final movie in data)
                                    InkWell(
                                      onDoubleTap: () {
                                        if(ref.read(searchqueryProvider) == ""){
                                          deleteFromLikedMovies(movie,movie.movieid ?? '',ref);
                                          setState(() {
                                            data.remove(movie);
                                          });
                                        } else {
                                          addToLikedMovies(movie, ref);
                                        }
                                        // ref.refresh(likedMovieProvider);
                                        },
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
                              );
                              },
                            error: (error,stack) {
                              return Center(
                                child: Text(
                                  'No movies found',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              );
                            },
                            loading: (){
                              return Center(child: CircularProgressIndicator());
                            }),
                        // ref.watch(repositoryInitializerProvider).when(
                        //   error: (error, _) => Text(error.toString()),
                        //   loading: () => const CircularProgressIndicator(),
                        //   data: (_) {
                        //     final state  = ref.offlinemodels.watchAll();
                        //     if (state.isLoading) {
                        //       return CircularProgressIndicator();
                        //     }
                        //     return Text(state.toString());
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
          ),]
      ),
    );
  }
}