import '../../domain/entities/forecast.dart';

class ForecastModel extends Forecast {
  const ForecastModel({
    required super.date,
    required super.temperature,
    required super.description,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: json['dt_txt'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}