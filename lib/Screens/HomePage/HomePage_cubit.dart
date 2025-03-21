import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoctive_test/Model/ImageData_model.dart';
import 'package:innoctive_test/Screens/HomePage/HomePage_state.dart';

class HomePageCubit extends Cubit<HomePage_state> {
  final Dio _dio = Dio();

  final int _limit = 100;
  bool hasMore = true;
  HomePageCubit() : super(HomePageInitial());

  Future<List<ImageData_model>> getDatafromApi(var page) async {
    try {
      Response response = await _dio.get(
        "https://api.thedogapi.com/v1/images/search?limit=$_limit&page=$page&order=Desc",
      );

      if (response.statusCode == 200) {
        //List<dynamic> data = response.data;

        List<ImageData_model> imagedata = (response.data as List)
            .map((json) => ImageData_model.fromJson(json))
            .toList();
        if (page == 0) {
          imagedata;
        } else {
          imagedata = List.from(imagedata)..addAll(imagedata);
          emit(HomePageLoaded(imagedata));
        }
        return imagedata;
      } else {
        throw Exception('Fails to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void fetchData(var page) async {
    try {
      final imagedata = await getDatafromApi(page);
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
