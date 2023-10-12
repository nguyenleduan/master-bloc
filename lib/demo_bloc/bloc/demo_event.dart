part of 'demo_bloc.dart';
abstract class DemoEvent {}
class CallApi extends DemoEvent {
  String url;
  CallApi(this.url);}
class SendOTP extends DemoEvent {
  String phone;
  SendOTP(this.phone);
}
class ConfirmOTP extends DemoEvent {
  String otp;
  ConfirmOTP(this.otp);
}




