
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Photo {
  final int id;
  final int sol;
  @JsonKey(name: 'earth_date')
  final String earthDate;
  final String roverName;
  final String cameraName;
  @JsonKey(name: 'img_src')
  final String imageUrl;

  Photo(this.id, this.sol, this.earthDate, this.cameraName, this.imageUrl, this.roverName);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}


Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
  json['id'] as int,
  json['sol'] as int,
  json['earth_date'] as String,
  json['camera']['name'] as String,
  json['img_src'] as String,
  json['rover']['name'] as String,
);//I editted my self to make it faster for child fields

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
  'id': instance.id,
  'sol': instance.sol,
  'earthDate': instance.earthDate,
  'roverName': instance.roverName,
  'cameraName': instance.cameraName,
  'imageUrl': instance.imageUrl,
};
