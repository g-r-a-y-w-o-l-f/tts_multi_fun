
abstract class RecordSendVoiceEvent {}
class ViewVoiceInitial extends RecordSendVoiceEvent {}
class StartRecording extends RecordSendVoiceEvent {}
class StopRecording extends RecordSendVoiceEvent {}
class ConvertToMp3  extends RecordSendVoiceEvent {}
class SendRecording extends RecordSendVoiceEvent {
  final String voiceName;
  final String voiceDescription;
  SendRecording({
    required this.voiceName,
    required this.voiceDescription
  });
}
class ResetRecording extends RecordSendVoiceEvent {}
class PlayRecording extends RecordSendVoiceEvent {}
class StopPlayback extends RecordSendVoiceEvent {}