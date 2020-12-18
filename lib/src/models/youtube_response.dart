// To parse this JSON data, do
//
//     final youtubeResponse = youtubeResponseFromJson(jsonString);

import 'dart:convert';

List<YoutubeResponse> youtubeResponseFromJson(String str) => List<YoutubeResponse>.from(json.decode(str).map((x) => YoutubeResponse.fromJson(x)));

String youtubeResponseToJson(List<YoutubeResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YoutubeResponse {
  int id;
  String youtubeId;
  Categories categories;
  String title;
  String subtitle;
  String avatarImage;
  String youtubeImage;
  DateTime createdAt;
  DateTime updatedAt;

  YoutubeResponse({
    this.id,
    this.youtubeId,
    this.categories,
    this.title,
    this.subtitle,
    this.avatarImage,
    this.youtubeImage,
    this.createdAt,
    this.updatedAt,
  });

  factory YoutubeResponse.fromJson(Map<String, dynamic> json) => YoutubeResponse(
    id: json["id"],
    youtubeId: json["youtube_id"],
    categories: categoriesValues.map[json["categories"]],
    title: json["title"],
    subtitle: json["subtitle"],
    avatarImage: json["avatar_image"],
    youtubeImage: json["youtube_image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "youtube_id": youtubeId,
    "categories": categoriesValues.reverse[categories],
    "title": title,
    "subtitle": subtitle,
    "avatar_image": avatarImage,
    "youtube_image": youtubeImage,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

enum Categories { SONGS, SUPERHERO, FOODS }

final categoriesValues = EnumValues({
  "foods": Categories.FOODS,
  "songs": Categories.SONGS,
  "superhero": Categories.SUPERHERO
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
