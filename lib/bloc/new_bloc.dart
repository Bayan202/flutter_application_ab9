import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'new_event.dart';
import 'new_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<FetchPostEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
        if (response.statusCode == 200) {
          final posts = json.decode(response.body);
          emit(PostLoaded(posts));
        } else {
          emit(PostError());
        }
      } catch (e) {
        emit(PostError());
      }
    });
  }
}
