// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

import 'demo_bloc/demo_screen.dart';
void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const AppView());
}

class AppBlocObserver extends BlocObserver {
  /// {@macro app_bloc_observer}
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc,
      Transition<dynamic, dynamic> transition,
      ) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  /// {@macro app_view}
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DemoScreen(),
    );
  }
}

class CounterPage extends StatelessWidget {
  /// {@macro counter_page}
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const CounterView(),
    );
  }
}
class CounterView extends StatelessWidget {
  /// {@macro counter_view}
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          children: [
            BlocBuilder<CounterBloc, ItemState>(
            buildWhen: (previous, current) => current is StartDelayState,
            builder:(context, state) {
              print('START-----------');
              return state is StartDelayState ? Container(width: 111,height: 222,color: Colors.blue,): SizedBox();
            },
          ),
            BlocBuilder<CounterBloc, ItemState>(
            buildWhen: (previous, current) => current is EndDelayState,
            builder:(context, state) {
              print('END-----------');
              return state is EndDelayState ? Container(width: 111,height: 222,color: Colors.yellow,): SizedBox();
            },
          ),
            BlocBuilder<CounterBloc, ItemState>(
            buildWhen: (previous, current) => current is CountState,
            builder:(context, state) {
              print("111111111");
              if(state is CountState){
                return Text(
                  '${state.index}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              }else{
                return Text(
                  '111',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              }
            },
          ),
            BlocBuilder<CounterBloc, ItemState>(
              builder:(context, state) {
                if(state is CountState){
                  return Text(
                    '${state.index}',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                }else{
                 return Text(
                    '111',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.read<CounterBloc>().add(CounterIncrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<CounterBloc>().add(CounterDecrementPressed());
            },
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<CounterBloc>().add(DelayPressed());
              // context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

class CounterBloc extends Bloc<CounterEvent, ItemState> {
  int dex = 0;
  /// {@macro counter_bloc}
  CounterBloc() : super(InitState()) {
    on<CounterIncrementPressed>((event, emit) {
      emit(CountState(dex));
    });
    on<DelayPressed>(_onUsernameChanged);
    on<CounterDecrementPressed>((event, emit) => emit(DecrementState(state.index -1)));
  }
  Future<void> _onUsernameChanged(DelayPressed event, Emitter<ItemState> emit) async {

    Timer _timer;
    int _start = 10;
    emit(StartDelayState());
    const oneSec = const Duration(seconds: 1);
    var url =
    Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'}); 
    var response = await http.get(url);
    if (response.statusCode == 200) {
      emit(EndDelayState());
    }
  }
}
abstract class ItemState  {
  int index = 0;
  final List? propss;
  ItemState([this.propss]);
  @override
  List<Object?> get props => (propss ?? []);
}

class InitState extends ItemState {
  InitState() : super([]);
  @override
  String toString() => 'InitState';
}
class CountState extends ItemState {
  int count;
  CountState(this.count) : super([]);
  @override
  String toString() => '$count';
}
class StartDelayState extends ItemState {
  StartDelayState( ) : super([]);
  @override
  String toString() => 'At';
}
class EndDelayState extends ItemState {
  EndDelayState( ) : super([]);
  @override
  String toString() => 'At';
}
class DecrementState extends ItemState {
  int count;
  DecrementState(this.count) : super([]);
  @override
  String toString() => '$count';
}
abstract class CounterEvent {}

class CounterIncrementPressed extends CounterEvent {}
class DelayPressed extends CounterEvent {}
class CounterDecrementPressed extends CounterEvent {}


class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}