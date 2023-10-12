
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';


part 'demo_state.dart';
part 'demo_event.dart';

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(InitState()) {
    on<CallApi>(_onUsernameChanged); // thêm function theo event
  }
   void _onUsernameChanged(CallApi event, Emitter<DemoState> emit ) async {
    try{
      emit(LoadingState()); // chuyển trạng thái Loading
      var response = await http.get(Uri.https('www.googleapis.com',  event.url , {'q': '{http}'})); // call api
      if (response.statusCode == 200) {
        emit(CallApiSuccessState('${response.statusCode}')); // trạng thái success
      }else{
        emit(CallApiFailState('${response.statusCode}','Message fail')); // trạng thái Fail
      }
    }catch(e){
      emit(ErrorState(e.toString())); // trạng thái Error
    }
  }
}







