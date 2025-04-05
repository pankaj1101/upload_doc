import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class HttpServices {
  final String baseUrl = "https://freeimage.host/api/1/upload";
  final String key = '6d207e02198a847aa98d0a2a901485a5';

  Future<dynamic> uploadImage(XFile imageFile) async {
    try {
      final request = MultipartRequest('POST', Uri.parse(baseUrl));

      request.files.add(
        await MultipartFile.fromPath(
          'source',
          imageFile.path,
        ),
      );

      request.fields['action'] = 'upload';
      request.fields['key'] = key;
      request.fields['source'] = imageFile.path.split('/').last;
      request.headers['Content-Type'] = 'application/json';

      final response = await request
          .send()
          .then((response) => response.stream.bytesToString())
          .then((value) => jsonDecode(value));

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
