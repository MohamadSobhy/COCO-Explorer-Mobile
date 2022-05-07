import 'package:equatable/equatable.dart';

class CocoImage extends Equatable {
  final int id;
  final String cocoUrl;
  final String flickrUrl;
  final List<String> captions;
  final List<ImageSegmentation> segmentations;

  const CocoImage({
    required this.id,
    required this.cocoUrl,
    required this.flickrUrl,
    required this.captions,
    required this.segmentations,
  });

  @override
  List<Object?> get props => [id, cocoUrl, flickrUrl, captions, segmentations];
}

class ImageSegmentation extends Equatable {
  final int categoryId;
  final List<num> points;

  const ImageSegmentation({required this.categoryId, required this.points});

  @override
  List<Object?> get props => [categoryId, points];
}
