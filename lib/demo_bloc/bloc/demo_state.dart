part of 'demo_bloc.dart';
abstract class DemoState  {
  final List? propss;
  DemoState([this.propss]);
  @override
  List<Object?> get props => (propss ?? []);
}
class LoadingState extends DemoState {
  String? message;
  LoadingState({this.message} ) : super([]);
  @override
  String toString() => 'LoadingState';
}
class CallApiSuccessState extends DemoState {
  String requestCode;
  CallApiSuccessState(this.requestCode ) : super([]);
  @override
  String toString() => 'CallApiSuccessState';
}
class CallApiFailState extends DemoState {
  String requestCode;
  String message;
  CallApiFailState(this.requestCode ,this.message ,) : super([]);
  @override
  String toString() => 'CallApiFailState';
}
class ErrorState extends DemoState {
  String error;
  ErrorState(this.error ) : super([]);
  @override
  String toString() => 'ErrorState';
}
class InitState extends DemoState {
  InitState() : super([]);
  @override
  String toString() => 'InitState';
}