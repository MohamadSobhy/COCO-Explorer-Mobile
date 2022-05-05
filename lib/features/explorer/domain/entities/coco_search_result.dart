import 'package:equatable/equatable.dart';

import 'coco_image.dart';

abstract class CocoSearchResult extends Equatable {
  final List<CocoImage> images;

  const CocoSearchResult({required this.images});
}
