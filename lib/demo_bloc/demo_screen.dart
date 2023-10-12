import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_bloc/demo_bloc/bloc/demo_bloc.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final bloc = DemoBloc();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DemoBloc,DemoState>(
      bloc:bloc,
      listener: (context, state) {
        if(state is ErrorState){
          /// Thông báo lỗi với nội dụng thông qua biến state.error
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Call Api"),
          ),
          body: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              children: [
                BlocBuilder<DemoBloc,DemoState>(
                  bloc: bloc,
                  buildWhen: (previous, current) => current is LoadingState,
                  builder: (context, state) {
                    if(state is LoadingState){
                      return Expanded(
                        child: Container( 
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(state.message ??""),
                        ),
                      );
                    }
                    return const  SizedBox();
                  },
                ),
                BlocBuilder<DemoBloc,DemoState>( /// Call api 1
                  bloc: bloc,
                  // buildWhen: (previous, current) => current is CallApiSuccessState,
                  builder: (context, state) {
                    if(state is CallApiSuccessState){
                      return Expanded(
                        child: Container( 
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: const Text( "Success"),
                        ),
                      );
                    } else  if( state is CallApiFailState){
                      return Expanded(
                        child: Container( 
                          color: Colors.red,
                          alignment: Alignment.center,
                          child:  const Text("Fail"),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ), floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                bloc.add(CallApi('/books/v1/volumes')); // URL đúng
              },
            ),
            FloatingActionButton(
              child: const Icon(Icons.wb_cloudy,color: Colors.red,),
              onPressed: () {
                bloc.add(CallApi('/books/v1/volERROR')); // URL sai
              },
            ),
          ],
        ),
        );
      },
    );
  }
}
