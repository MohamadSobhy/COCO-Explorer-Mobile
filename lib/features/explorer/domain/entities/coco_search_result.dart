import 'package:equatable/equatable.dart';

import 'coco_image.dart';

abstract class CocoSearchResult extends Equatable {
  final List<CocoImage> images;
  final int total;

  const CocoSearchResult({
    required this.images,
    required this.total,
  });
}
