import 'dart:async';
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_bloc/ticker.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _durathion = 60;

  StreamSubscription<int> _tickerSubscription;
  TimerBloc({Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(_durathion));

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerTricked) {
      yield* _mapTimerTrickedToState(event);
    }
  }

  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.durathion);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.durathion)
        .listen((durathion) => add(TimerTricked(durathion: durathion)));
  }

  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription.pause();
      yield TimerRunPause(state.durathion);
    }
  }

  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      yield TimerRunInProgress(state.durathion);
    }
  }

  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscription?.cancel();
    yield TimerInitial(_durathion);
  }

  Stream<TimerState> _mapTimerTrickedToState(TimerTricked tick) async* {
    yield tick.durathion > 0
        ? TimerRunInProgress(tick.durathion)
        : TimerRunCompelete();
  }
}
