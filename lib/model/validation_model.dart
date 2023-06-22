class ValidationModel {
  int expandedTileIndex;
  String expandedTileName;
  String title;

  ValidationModel({
    required this.expandedTileIndex,
    required this.expandedTileName,
    required this.title,
  });
}

// class ValidationModel {
//   int expandedTileIndex;
//   String expandedTileName;
//   List<String> title;

//   ValidationModel({
//     required this.expandedTileIndex,
//     required this.expandedTileName,
//     required this.title,
//   });

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['expandedTileIndex'] = expandedTileIndex;
//     map['expandedTileName'] = expandedTileName;
//     map['title'] = title;
//     return map;
//   }
// }



