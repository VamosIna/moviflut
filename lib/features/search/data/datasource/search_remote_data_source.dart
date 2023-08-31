import 'package:dio/dio.dart';
import 'package:movie_app/core/data/error/exceptions.dart';
import 'package:movie_app/core/data/network/api_constants.dart';
import 'package:movie_app/core/data/network/error_message_model.dart';
import 'package:movie_app/features/search/data/models/search_result_item_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultItemModel>> search(String title);
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final Dio dio = Dio();
  @override
  Future<List<SearchResultItemModel>> search(String title) async {
    dio.interceptors.add(PrettyDioLogger(responseBody: true));
    print("JANCOK");
    final response = await dio.get(ApiConstants.getSearchPath(title));
    if (response.statusCode == 200) {
      return List<SearchResultItemModel>.from((response.data['results'] as List)
          .where((e) => e['media_type'] != 'person')
          .map((e) => SearchResultItemModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
