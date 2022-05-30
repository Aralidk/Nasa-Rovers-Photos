import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/photo.dart';
import 'models/rover.dart';


class NasaHelper {
  static Future<PhotosResponse> fetchRover({required Rover rover,required int sol, required String camera}) async {
    var apikey = 'xmsIzL71EgjdxsimHnTdrBYCW5wgax1UIxciEUaW';
    var response = await http.get(Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/${rover.name}/photos?sol=$sol&camera=$camera&api_key=$apikey'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> images = data['photos'];
      return PhotosResponse(images.map((e) => Photo.fromJson(e)));
    }
    throw StateError('Error while requesting' + response.statusCode.toString());
  }
}

class PhotosResponse {
  final Iterable<Photo> photos;
  PhotosResponse(this.photos);
}