import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/feature/weather/data/dataSources/weather_remote_datasource.dart';

import 'feature/weather/data/dataSources/weather_local_datasource.dart';
import 'feature/weather/data/repositories/weather_repository_impl.dart';
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
  final bloc = WeatherBloc(getWeather,repository);

  runApp(BlocProvider(create: (context) => bloc..add(LoadSearchHistoryEvent()), child: const MyApp()));
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
        home: const WeatherPage(),
    );
  }
}

