import 'package:innoctive_test/Model/ImageData_model.dart';

class HomePage_state {}

class HomePageInitial extends HomePage_state {
  // HomePageInitial();
}

class HomePageLoading extends HomePage_state {}

class HomePageLoaded extends HomePage_state {
  List<ImageData_model> data;

  HomePageLoaded(this.data);
}

class HomePageError extends HomePage_state {
  final String error;
  HomePageError(this.error);
}
