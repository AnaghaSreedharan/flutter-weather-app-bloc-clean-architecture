import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/feature/weather/data/dataSources/weather_remote_datasource.dart';

import 'feature/favorites/data/datasources/favourites_local_datasource.dart';
import 'feature/favorites/data/respositories/favourites_repository_impl.dart';
import 'feature/favorites/domain/useCases/add_favourite.dart';
import 'feature/favorites/domain/useCases/check_favourite.dart';
import 'feature/favorites/domain/useCases/get_favourites.dart';
import 'feature/favorites/domain/useCases/remove_favourite.dart';
import 'feature/favorites/presentation/bloc/favourites_bloc.dart';
import 'feature/favorites/presentation/bloc/favourites_event.dart';
import 'feature/favorites/presentation/pages/favourites_page.dart';
import 'feature/weather/data/dataSources/weather_local_datasource.dart';
import 'feature/weather/data/repositories/weather_repository_impl.dart';
import 'feature/weather/domain/usecases/get_forecast.dart';
import 'feature/weather/domain/usecases/get_weather.dart';
import 'feature/weather/presentation/bloc/weather_bloc.dart';
import 'feature/weather/presentation/bloc/weather_event.dart';
import 'feature/weather/presentation/pages/weather_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = http.Client();
  final prefs = await SharedPreferences.getInstance();
  final dataSource = WeatherRemoteDatasourceImpl(client);
  final localDataSource = WeatherLocalDataSourceImpl(prefs);
  final repository = WeatherRepositoryImpl(dataSource,localDataSource);
  final getWeather = GetWeather(repository);
  final getForecast = GetForecast(repository);

  // Favourites feature
  final favouritesLocalDataSource = FavouritesLocalDatasourceImpl(prefs);
  final favouritesRepository = FavouritesRepositoryImpl(
    favouritesLocalDataSource,
  );
  final getFavourites = GetFavourites(favouritesRepository);
  final addFavourite = AddFavourite(favouritesRepository);
  final removeFavourite = RemoveFavourite(favouritesRepository);
  final checkFavourite = CheckFavourite(favouritesRepository);


  runApp(  MultiBlocProvider(
    providers: [
      // Weather BLoC — global
      BlocProvider(
        create: (_) => WeatherBloc(
          getWeather,
          getForecast,
          repository,
        )..add(LoadSearchHistoryEvent()),
      ),

      // Favourites BLoC — global
      BlocProvider(
        create: (_) => FavouritesBloc(
          getFavourites: getFavourites,
          addFavourite: addFavourite,
          removeFavourite: removeFavourite,
          checkFavourite: checkFavourite,
        )..add(LoadFavouritesEvent()),
      ),
    ], child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
        home: const MainScreen(),
    );
  }

}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WeatherPage(),
    FavouritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}


