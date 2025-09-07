part of 'voice_control_cubit.dart';

@immutable
sealed class VoiceControlState {}

final class VoiceControlInitial extends VoiceControlState {}

final class VoiceControlLoading extends VoiceControlState {}

final class VoiceControlSuccess extends VoiceControlState {
  final TodoModel todoModel;
  VoiceControlSuccess(this.todoModel);
}

final class VoiceControlError extends VoiceControlState {
  final String error;
  VoiceControlError(this.error);
}
