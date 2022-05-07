class ApiEndpoints {
  //! Private members
  static const String _baseUrl =
      'https://us-central1-open-images-dataset.cloudfunctions.net/';

  static const String imagesBaseUrl =
      'https://cocodataset.org/images/cocoicons/';

  static const String _cocoDatasetEndpoint = 'coco-dataset-bigquery';

  //! Public members
  static const String cocoDatasetEndpointUrl = _baseUrl + _cocoDatasetEndpoint;
}
