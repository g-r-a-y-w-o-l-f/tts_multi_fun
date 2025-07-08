import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';

import 'eleven_speech_dialog_event.dart';
import 'eleven_speech_dialog_state.dart';

class ElevenSpeechDialogBloc extends Bloc<ElevenSpeechDialogEvent, ElevenSpeechDialogState> {
  ElevenSpeechDialogBloc({required ElevenVoice initSetup}) : super(ElevenSpeechDialogState(setupParams: initSetup)) {
    on<OpenSetupSpeechDialogEvent>((event, emit) {
      // ...
    });

    on<SaveSetupSpeechDialogEvent>((event, emit) {
      emit(state.copyWith(setupParams: event.setupParams));
    });
  }
}

