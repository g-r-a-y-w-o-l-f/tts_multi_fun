abstract class RecordSendVoiceState {
  late String failureMessage;
  late String filePath;
}

class VoiceInitial extends RecordSendVoiceState {}

class RecordingInProgress extends RecordSendVoiceState {}
class RecordingCompleted extends RecordSendVoiceState {
  final String filePath;
  RecordingCompleted(this.filePath);
}
class RecordingFailure extends RecordSendVoiceState {
  @override
  String failureMessage;

  RecordingFailure({
    required this.failureMessage,
  });
}

class ConvertingInProgress extends RecordSendVoiceState {}
class ConvertingSuccess extends RecordSendVoiceState {
  @override
  final String filePath;
  ConvertingSuccess(this.filePath);
}
class ConvertingFailure extends RecordSendVoiceState {
  @override
  String failureMessage;

  ConvertingFailure({
    required this.failureMessage,
  });
}

class SendingInProgress extends RecordSendVoiceState {}
class SendingSuccess extends RecordSendVoiceState {}
class SendingFailure extends RecordSendVoiceState {
  @override
  String failureMessage;

  SendingFailure({
    required this.failureMessage,
  });
}
class PlayingRecording extends RecordSendVoiceState {
  @override
  String filePath;
  PlayingRecording(this.filePath);
}
class PlaybackStopped extends RecordSendVoiceState {
  @override
  final String filePath;
  PlaybackStopped(this.filePath);
}
