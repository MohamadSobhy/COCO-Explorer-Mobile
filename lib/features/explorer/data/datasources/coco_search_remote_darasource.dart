import '../../../../core/api_handler/api_base_handler.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/network/network_info.dart';
import '../models/coco_search_result_model.dart';

abstract class CocoSearchRemoteDataSource {
  Future<CocoSearchResultModel> searchCocoDataset(
    List<int> categoryIds, {
    int page = 1,
  });
}

class CocoSearchRemoteDataSourceImpl implements CocoSearchRemoteDataSource {
  final ApiHandler apiHandler;
  final NetworkInfo networkInfo;

  CocoSearchRemoteDataSourceImpl({
    required this.apiHandler,
    required this.networkInfo,
  });

  List<int> _fetchedImagesIds = [];

  @override
  Future<CocoSearchResultModel> searchCocoDataset(
    List<int> categoryIds, {
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      List<int> imagesToBeLoaded = [];

      if (page == 1) {
        final imagesIdsJson = await _fetchImagesByCategories(categoryIds) ?? [];

        _fetchedImagesIds = List<int>.from(imagesIdsJson as List<dynamic>);
        if (_fetchedImagesIds.length >= 5) {
          imagesToBeLoaded = _fetchedImagesIds.sublist(0, 5);
        } else {
          imagesToBeLoaded = _fetchedImagesIds;
        }
      } else {
        if (_fetchedImagesIds.length >= page * 5) {
          imagesToBeLoaded =
              _fetchedImagesIds.sublist((page - 1) * 5, page * 5);
        } else {
          imagesToBeLoaded = _fetchedImagesIds.sublist(
            (page - 1) * 5,
            _fetchedImagesIds.length,
          );
        }
      }

      late List result = [[], [], []];

      if (imagesToBeLoaded.isNotEmpty) {
        result = await Future.wait([
          _fetchImagesDetails(imagesToBeLoaded),
          _fetchImagesSegmentations(imagesToBeLoaded),
          _fetchImagesCaptions(imagesToBeLoaded),
        ]);
      }

      return CocoSearchResultModel.fromJson(
        result[0],
        result[1],
        result[1],
        total: _fetchedImagesIds.length,
      );
    } else {
      throw NetworkException(
        message: 'please check your internet connectionand try again.',
      );
    }
  }

  Future _fetchImagesByCategories(List<int> categoryIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"category_ids": categoryIds, "querytype": "getImagesByCats"},
    );
  }

  Future _fetchImagesDetails(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": imagesIds, "querytype": "getImages"},
    );
  }

  Future _fetchImagesSegmentations(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": imagesIds, "querytype": "getInstances"},
    );
  }

  Future _fetchImagesCaptions(List<int> imagesIds) {
    return apiHandler.post(
      ApiEndpoints.cocoDatasetEndpointUrl,
      body: {"image_ids": imagesIds, "querytype": "getCaptions"},
    );
  }
}
