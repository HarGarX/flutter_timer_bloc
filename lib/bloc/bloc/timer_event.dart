part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int durathion;
  const TimerStarted({this.durathion});
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTricked extends TimerEvent {
  const TimerTricked({this.durathion});
  final int durathion;

  @override
  List<Object> get props => [durathion];
}
