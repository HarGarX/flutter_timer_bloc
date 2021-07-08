part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int durathion;
  const TimerState(this.durathion);

  @override
  List<Object> get props => [durathion];
}

class TimerInitial extends TimerState {
  const TimerInitial(int durathion) : super(durathion);
  @override
  String toString() => 'TimerInital {durathion : $durathion}';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(int durathion) : super(durathion);
  @override
  String toString() => 'TimerRunPause {durathion : $durathion}';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int durathion) : super(durathion);
  @override
  String toString() => 'TimerRunInPreogress{durathion : $durathion}';
}

class TimerRunCompelete extends TimerState {
  TimerRunCompelete() : super(0);
}
