import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/settings.dart';
import 'azure_tts_event.dart';
import 'azure_tts_state.dart';

class AzureTtsBloc extends Bloc<AzureTtsEvent, AzureTtsState> {
  AzureTtsBloc({required VoiceSetup initialSettings}) : super(AzureTtsState(settings: initialSettings)) {
    on<OpenSettingsDialogEvent>((event, emit) {
      // ...
    });

    on<SaveSettingsEvent>((event, emit) {
      emit(state.copyWith(settings: event.settings));
    });
  }
}

