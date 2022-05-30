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
  @JsonKey(name: 'landing_date')
  final String landingDate;
  @JsonKey(name: 'launch_date')
  final String launchDate;
  @JsonKey(name: 'status')
  final String Status;

  Photo(this.id, this.sol, this.earthDate, this.cameraName, this.imageUrl, this.roverName, this.landingDate, this.launchDate, this.Status);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _PhotoFromJson(json);

  Map<String, dynamic> toJson() => _PhotoToJson(this);
}


Photo _PhotoFromJson(Map<String, dynamic> json) => Photo(
  json['id'] as int,
  json['sol'] as int,
  json['earth_date'] as String,
  json['camera']['name'] as String,
  json['img_src'] as String,
  json['rover']['name'] as String,
  json['rover']['landing_date'] as String,
  json['rover']['launch_date'] as String,
  json['rover']['status'] as String


);

Map<String, dynamic> _PhotoToJson(Photo instance) => <String, dynamic>{
  'id': instance.id,
  'sol': instance.sol,
  'earthDate': instance.earthDate,
  'roverName': instance.roverName,
  'cameraName': instance.cameraName,
  'imageUrl': instance.imageUrl,
  'landingDate' : instance.landingDate,
  'launchingDate': instance.launchDate,
  'Status': instance.Status
};