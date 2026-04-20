import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/feature/weather/data/dataSources/weather_remote_datasource.dart';

import 'feature/weather/data/repositories/weather_repository_impl.dart';
import 'feature/weather/domain/usecases/get_weather.dart';
import 'feature/weather/presentation/bloc/weather_bloc.dart';
import 'feature/weather/presentation/pages/weather_page.dart';

void main() {
  final client = http.Client();
  final dataSource = WeatherRemoteDatasourceImpl(client);
  final repository = WeatherRepositoryImpl(dataSource);
  final getWeather = GetWeather(repository);
  final bloc = WeatherBloc(getWeather);

  runApp(BlocProvider(create: (context) => bloc, child: const MyApp()));
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

