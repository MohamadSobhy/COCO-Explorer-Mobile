import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/mixins/image_properties_mixin.dart';
import '../../domain/entities/coco_image.dart';
import '../bloc/explorer_bloc.dart';
import '../painters/segmentation_painter.dart';
import '../widgets/coco_search_loading_view.dart';

class SearchResultList extends StatelessWidget with ImagePropertiesMixin {
  final Function(BuildContext, {int page}) performCocoSearch;

  SearchResultList({
    Key? key,
    required this.performCocoSearch,
  }) : super(key: key);

  List<CocoImage> _loadedImages = [];

  final _scrollController = ScrollController();

  bool _canPaginate = true;

  int _page = 1;
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (ctx, state) {
        if (state is ExplorerLoadingState && state.page == 1) {
          _loadedImages.clear();
          return const CocoSearchLoadingView();
        } else if (state is ExplorerServerErrorState && state.page == 1) {
          _loadedImages.clear();
          return Center(child: Text(state.message));
        } else if (state is ExplorerNetworkErrorState && state.page == 1) {
          _loadedImages.clear();
          return Center(child: Text(state.message));
        } else if (state is ExplorerResultFetchedState) {
          if (state.page == 1) {
            if (state.result.images.isEmpty) {
              return const Center(child: Text('No Result '));
            }

            _loadedImages = state.result.images;
            _page = 1;
            _total = state.result.total;
            _canPaginate = _loadedImages.length < _total;
          } else {
            _loadedImages.addAll(state.result.images);
            _canPaginate = _loadedImages.length < _total;
          }
        } else {
          if (state.page == 1) _loadedImages.clear();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_total != 0)
              Text(
                '${_loadedImages.length}/$_total loaded',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            if (_total != 0) const SizedBox(height: 5),
            Expanded(
              child: ListView.separated(
                controller: _scrollController
                  ..addListener(() => _onScrolling(context)),
                itemCount: state is ExplorerLoadingState ||
                        state is ExplorerServerErrorState ||
                        state is ExplorerNetworkErrorState
                    ? _loadedImages.length + 1
                    : _loadedImages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  if (index == _loadedImages.length) {
                    final lastItemView = _handlePaginationState(state);
                    if (lastItemView != null) return lastItemView;
                  }

                  return FutureBuilder<SizedImage>(
                    future: getImageOriginalSize(_loadedImages[index].cocoUrl),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: snapshot.data == null ||
                                        !snapshot.hasData
                                    ? const CocoImageItemLoadingView()
                                    : CustomPaint(
                                        foregroundPainter: SegmentationsPainter(
                                          segmentations: _loadedImages[index]
                                              .segmentations,
                                          originalSize:
                                              snapshot.data?.originalSize,
                                        ),
                                        child:
                                            Image(image: snapshot.data!.image),
                                      ),
                              ),
                              if (snapshot.data == null || !snapshot.hasData)
                                _buildSegmentationLoadingView(context),
                              if (snapshot.hasError)
                                _buildLoadingImageSizeFailedView(),
                            ],
                          ),
                          if (_total == _loadedImages.length &&
                              index == _loadedImages.length - 1)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'No more images',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (_total == _loadedImages.length &&
                              index == _loadedImages.length - 1)
                            const SizedBox(height: 30),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget? _handlePaginationState(ExplorerState state) {
    if (state is ExplorerLoadingState) {
      return const CocoImageItemLoadingView();
    } else if (state is ExplorerServerErrorState) {
      return Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        child: Text(
          state.message,
          textAlign: TextAlign.center,
        ),
      );
    } else if (state is ExplorerNetworkErrorState) {
      return Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(15),
        child: Text(
          state.message,
          textAlign: TextAlign.center,
        ),
      );
    }

    return null;
  }

  Positioned _buildLoadingImageSizeFailedView() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'An Error happens while trying to calculate image size to draw segments',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Positioned _buildSegmentationLoadingView(context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(
                color: Colors.purpleAccent,
                radius: 15,
              ),
              const SizedBox(height: 10),
              Text(
                'Drawing Segments',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScrolling(context) {
    final currentExtent = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;

    if (_canPaginate && currentExtent >= maxExtent - 100) {
      _canPaginate = false;

      performCocoSearch(context, page: ++_page);
    }
  }
}
