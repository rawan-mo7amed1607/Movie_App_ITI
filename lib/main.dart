import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/movies/presentation/main_screen.dart';
import 'features/movies/logic/movies_cubit.dart';
import 'features/movies/data/movie_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit(MovieApiService())..fetchPopularMovies(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFFFC107),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFFFFC107),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1F1F1F),
            selectedItemColor: Color(0xFFFFC107),
            unselectedItemColor: Colors.grey,
            elevation: 8,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}