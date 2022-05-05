import '../../domain/entities/coco_search_result.dart';
import 'coco_image_model.dart';

class CocoSearchResultModel extends CocoSearchResult {
  const CocoSearchResultModel({
    required List<CocoImageModel> images,
  }) : super(images: images);

  factory CocoSearchResultModel.fromJson(
    List<dynamic> imagesJson,
    List<dynamic> segmentationJson,
    List<dynamic> captionsJson,
  ) {
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

    return CocoSearchResultModel(images: parsedImages);
  }

  @override
  List<Object?> get props => [images];
}
