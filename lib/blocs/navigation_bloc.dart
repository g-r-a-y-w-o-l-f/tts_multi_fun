import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvent {selection_screen, tts_offline_screen, tts_online_screen, tts_online_jay_screen}

class NavigationBloc extends Cubit<NavigationEvent> {
  NavigationBloc() : super(NavigationEvent.selection_screen);
  void navigateTo(NavigationEvent event) => emit(event);
}