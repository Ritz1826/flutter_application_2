// To parse this JSON data, do
//
//     final userImages = userImagesFromJson(jsonString);

import 'dart:convert';

UserImages userImagesFromJson(String str) =>
    UserImages.fromJson(json.decode(str));

String userImagesToJson(UserImages data) => json.encode(data.toJson());

class UserImages {
  int resultCount;
  int pageCount;
  int pageSize;
  int page;
  List<UserImageData> results;

  UserImages({
    required this.resultCount,
    required this.pageCount,
    required this.pageSize,
    required this.page,
    required this.results,
  });

  factory UserImages.fromJson(Map<String, dynamic> json) => UserImages(
    resultCount: json["result_count"],
    pageCount: json["page_count"],
    pageSize: json["page_size"],
    page: json["page"],
    results: List<UserImageData>.from(
      json["results"].map((x) => UserImageData.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "result_count": resultCount,
    "page_count": pageCount,
    "page_size": pageSize,
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class UserImageData {
  String id;
  String title;
  DateTime indexedOn;
  String foreignLandingUrl;
  String url;
  String creator;
  String creatorUrl;
  License license;
  String licenseVersion;
  String licenseUrl;
  Provider provider;
  Provider source;
  dynamic category;
  dynamic filesize;
  dynamic filetype;
  List<Tag> tags;
  String attribution;
  List<FieldsMatched> fieldsMatched;
  bool mature;
  int height;
  int width;
  String thumbnail;
  String detailUrl;
  String relatedUrl;
  List<dynamic> unstableSensitivity;

  UserImageData({
    required this.id,
    required this.title,
    required this.indexedOn,
    required this.foreignLandingUrl,
    required this.url,
    required this.creator,
    required this.creatorUrl,
    required this.license,
    required this.licenseVersion,
    required this.licenseUrl,
    required this.provider,
    required this.source,
    required this.category,
    required this.filesize,
    required this.filetype,
    required this.tags,
    required this.attribution,
    required this.fieldsMatched,
    required this.mature,
    required this.height,
    required this.width,
    required this.thumbnail,
    required this.detailUrl,
    required this.relatedUrl,
    required this.unstableSensitivity,
  });

  factory UserImageData.fromJson(Map<String, dynamic> json) => UserImageData(
    id: json["id"],
    title: json["title"],
    indexedOn: DateTime.parse(json["indexed_on"]),
    foreignLandingUrl: json["foreign_landing_url"],
    url: json["url"],
    creator: json["creator"] ?? "",
    creatorUrl: json["creator_url"] ?? "",
    license: licenseValues.map[json["license"]] ?? License.BY,
    licenseVersion: json["license_version"],
    licenseUrl: json["license_url"],
    provider: providerValues.map[json["provider"]] ?? Provider.CLARIFAI,
    source: providerValues.map[json["source"]] ?? Provider.FLICKR,
    category: json["category"],
    filesize: json["filesize"],
    filetype: json["filetype"],
    tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
    attribution: json["attribution"],
    fieldsMatched: List<FieldsMatched>.from(
      json["fields_matched"].map((x) => fieldsMatchedValues.map[x]!),
    ),
    mature: json["mature"],
    height: json["height"],
    width: json["width"],
    thumbnail: json["thumbnail"],
    detailUrl: json["detail_url"],
    relatedUrl: json["related_url"],
    unstableSensitivity: List<dynamic>.from(
      json["unstable__sensitivity"].map((x) => x),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "indexed_on": indexedOn.toIso8601String(),
    "foreign_landing_url": foreignLandingUrl,
    "url": url,
    "creator": creator,
    "creator_url": creatorUrl,
    "license": licenseValues.reverse[license],
    "license_version": licenseVersion,
    "license_url": licenseUrl,
    "provider": providerValues.reverse[provider],
    "source": providerValues.reverse[source],
    "category": category,
    "filesize": filesize,
    "filetype": filetype,
    "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
    "attribution": attribution,
    "fields_matched": List<dynamic>.from(
      fieldsMatched.map((x) => fieldsMatchedValues.reverse[x]),
    ),
    "mature": mature,
    "height": height,
    "width": width,
    "thumbnail": thumbnail,
    "detail_url": detailUrl,
    "related_url": relatedUrl,
    "unstable__sensitivity": List<dynamic>.from(
      unstableSensitivity.map((x) => x),
    ),
  };
}

enum FieldsMatched { DESCRIPTION, TAGS_NAME, TITLE }

final fieldsMatchedValues = EnumValues({
  "description": FieldsMatched.DESCRIPTION,
  "tags.name": FieldsMatched.TAGS_NAME,
  "title": FieldsMatched.TITLE,
});

enum License { BY, BY_NC, BY_NC_ND, BY_NC_SA }

final licenseValues = EnumValues({
  "by": License.BY,
  "by-nc": License.BY_NC,
  "by-nc-nd": License.BY_NC_ND,
  "by-nc-sa": License.BY_NC_SA,
});

enum Provider { CLARIFAI, FLICKR }

final providerValues = EnumValues({
  "clarifai": Provider.CLARIFAI,
  "flickr": Provider.FLICKR,
});

class Tag {
  String name;
  double? accuracy;
  Provider unstableProvider;

  Tag({
    required this.name,
    required this.accuracy,
    required this.unstableProvider,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json["name"],
    accuracy: json["accuracy"]?.toDouble(),
    unstableProvider: providerValues.map[json["unstable__provider"]]!,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "accuracy": accuracy,
    "unstable__provider": providerValues.reverse[unstableProvider],
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
