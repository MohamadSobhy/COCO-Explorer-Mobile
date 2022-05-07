import '../../domain/entities/coco_search_result.dart';
import 'coco_image_model.dart';

class CocoSearchResultModel extends CocoSearchResult {
  const CocoSearchResultModel({
    required List<CocoImageModel> images,
    required int total,
  }) : super(images: images, total: total);

  factory CocoSearchResultModel.fromJson(
    List<dynamic> imagesJson,
    List<dynamic> segmentationJson,
    List<dynamic> captionsJson, {
    int total = 5,
  }) {
    List<CocoImageModel> parsedImages = [];

    for (final image in imagesJson) {
      final segmentations = segmentationJson
          .where((element) => element['image_id'] == image['id'])
          .map((e) => ImageSegmentationModel.fromJson(e))
          .toList();

      final captions = captionsJson
          .where((element) => element['image_id'] == image['id'])
          .map((e) => e['caption'].toString())
          .toList();

      parsedImages.add(CocoImageModel.fromJson(image, segmentations, captions));
    }

    return CocoSearchResultModel(
      images: parsedImages,
      total: total,
    );
  }

  @override
  List<Object?> get props => [images];
}
