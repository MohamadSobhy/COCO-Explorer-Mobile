import 'dart:convert';

import '../../../../core/api_handler/api_base_handler.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/network/network_info.dart';
import '../models/coco_search_result_model.dart';

abstract class CocoSearchRemoteDataSource {
  Future<CocoSearchResultModel> searchCocoDataset(List<int> categoryIds);
}

class CocoSearchRemoteDataSourceImpl implements CocoSearchRemoteDataSource {
  final ApiHandler apiHandler;
  final NetworkInfo networkInfo;

  CocoSearchRemoteDataSourceImpl({
    required this.apiHandler,
    required this.networkInfo,
  });

  @override
  Future<CocoSearchResultModel> searchCocoDataset(List<int> categoryIds) async {
    if (await networkInfo.isConnected) {
      final imagesIdsJson = await _fetchImagesByCategories(categoryIds) ?? [];

      final imagesIds = List<int>.from(imagesIdsJson as List<dynamic>);

      final result = await Future.wait([
        _fetchImagesDetails(imagesIds),
        _fetchImagesSegmentations(imagesIds),
        _fetchImagesCaptions(imagesIds),
      ]);

      return CocoSearchResultModel.fromJson(result[0], result[1], result[2]);
    } else {
      throw NetworkException(
        message: 'please check your internet connectionand try again.',
      );
    }
  }

  Future _fetchImagesByCategories(List<int> categoryIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {
        "category_ids": json.encode(categoryIds),
        "querytype": "getImagesByCats"
      },
    );
  }

  Future _fetchImagesDetails(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": json.encode(imagesIds), "querytype": "getImages"},
    );
  }

  Future _fetchImagesSegmentations(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": json.encode(imagesIds), "querytype": "getInstances"},
    );
  }

  Future _fetchImagesCaptions(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": json.encode(imagesIds), "querytype": "getCaptions"},
    );
  }
}
