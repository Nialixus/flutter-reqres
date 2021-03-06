import 'dart:convert';
import 'package:http/http.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/resourcelist_model.dart';

part '../state/resourcelist_state.dart';

/// State used in [ResourceListWidget].
class ResourceListCubit extends Cubit<ResourceListState> {
  /// Initiating [ResourceListState].
  ResourceListCubit() : super(ResourceListLoading()) {
    fetching();
  }

  /// Fetching resource list from API.
  void fetching({int? page}) {
    get(
      Uri.parse('https://reqres.in/api/unknown?page=${page ?? 1}'),
    ).then((response) {
      try {
        var json = jsonDecode(response.body);
        if (response.statusCode == 200) {
          emit(ResourceListSucceed(model: ResourceListModel.fromJson(json)));
        } else {
          emit(ResourceListFailed(
              message: "${response.statusCode} ${response.reasonPhrase}"));
        }
      } catch (e) {
        emit(ResourceListFailed(message: e.toString()));
      }
    });
  }
}
