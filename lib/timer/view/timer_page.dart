import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_bloc/ticker.dart';
import 'package:flutter_timer_bloc/timer/timer.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Timer')),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final durathion = context.select((TimerBloc bloc) => bloc.state.durathion);
    final minutesStr =
        ((durathion / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (durathion % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context
                    .read<TimerBloc>()
                    .add(TimerStarted(durathion: state.durathion)),
              ),
            ],
            if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                child: Icon(Icons.pause),
                onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunCompelete) ...[
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ]
          ],
        );
      },
    );
  }
}
