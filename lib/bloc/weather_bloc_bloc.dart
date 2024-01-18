import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_apk/data/my_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async{
      // TODO: implement event handler
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.FRENCH);

        // Position position =  await Geolocator.getCurrentPosition();
        
        Weather weather = await wf.currentWeatherByLocation(
          event.position.latitude, 
          event.position.longitude,
        );
        print(weather);
        emit(WeatherBlocSucces(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });

    on<FetchCityWeather>((event, emit) async{
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.FRENCH);

        Weather weather = await wf.currentWeatherByCityName(
          event.city
        );
        print(weather);
        emit(WeatherBlocSucces(weather));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}
