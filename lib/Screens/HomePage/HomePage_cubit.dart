import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoctive_test/Model/ImageData_model.dart';
import 'package:innoctive_test/Screens/HomePage/HomePage_state.dart';

class HomePageCubit extends Cubit<HomePage_state> {
  final Dio _dio = Dio();
  HomePageCubit() : super(HomePageInitial());

  Future<List<ImageData_model>> getDatafromApi() async {
    try {
      Response response = await _dio.get(
          "https://api.thedogapi.com/v1/images/search?limit=100&page=0&order=Desc");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        List<ImageData_model> imagedata = (response.data as List)
            .map((json) => ImageData_model.fromJson(json))
            .toList();
        return imagedata;
      } else {
        throw Exception('Fails to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void fetchData() async {
    try {
      final imagedata = await getDatafromApi();
      if (imagedata.isNotEmpty) {
        emit(HomePageLoaded(imagedata));
      } else {
        emit(HomePageError("No Data Found"));
      }
    } catch (e) {
      emit(HomePageError('Fail to load data $e'));
    }
  }
}
