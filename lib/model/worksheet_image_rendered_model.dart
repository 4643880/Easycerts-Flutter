class WorksheetImageRenderedModel {
  String itemName, expandedTitleName, imageTitle, imageKey, uploadUrl, filePath;
  bool isRequired, isFilled;

  WorksheetImageRenderedModel({
    required this.itemName,
    required this.expandedTitleName,
    required this.imageTitle,
    required this.imageKey,
    required this.uploadUrl,
    required this.filePath,
    required this.isRequired,
    required this.isFilled,
  });
}
