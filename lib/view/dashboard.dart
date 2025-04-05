import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uploaddoc/service/http_services.dart';
import 'package:uploaddoc/widgets/app_button_with_icon.dart';
import 'package:uploaddoc/widgets/snackbar_utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child:
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onTapUploadImage,
                      child: Text('Upload Image'),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _imageUrlController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'Image URL will be displayed here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              _copyToClipboard();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Future<void> uploadImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      HttpServices httpServices = HttpServices();
      final response = await httpServices.uploadImage(_imageFile!);
      _imageUrlController.text = response['image']['url'] ?? '';

      setState(() {
        _imageFile = null;
      });

      if (response['image']['url'] != null) {
        if (!mounted) return;
        SnackBarUtils.showSnackbar(
          context: context,
          message: 'Image uploaded successfully: ${response['image']['url']}',
          snackbarType: SnackbarType.success,
        );
      } else {
        if (!mounted) return;
        SnackBarUtils.showSnackbar(
          context: context,
          message: 'Image upload failed',
        );
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showSnackbar(
        context: context,
        message: 'Error uploading image: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (_imageUrlController.text.isNotEmpty) {
      // Copy the URL to clipboard
      Clipboard.setData(ClipboardData(text: _imageUrlController.text));
      if (!mounted) return;
      SnackBarUtils.showSnackbar(
        context: context,
        message: 'Image URL copied to clipboard',
        snackbarType: SnackbarType.success,
      );
    } else {
      if (!mounted) return;
      SnackBarUtils.showSnackbar(
        context: context,
        message: 'No image URL to copy',
      );
    }
  }

  void onTapUploadImage() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bContext) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              AppButtonWithIcon(
                text: 'Camera',
                icon: Icons.camera_alt,
                onPressed: () async {
                  Navigator.pop(bContext); // Close the bottom sheet
                  final image = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _imageFile = image;
                    });
                    uploadImage();
                  } else {
                    if (!mounted) return;
                    SnackBarUtils.showSnackbar(
                      context: context,
                      message: 'No image selected',
                    );
                  }
                },
              ),

              const SizedBox(height: 10),

              AppButtonWithIcon(
                text: 'Gallery',
                icon: Icons.photo_library,
                onPressed: () async {
                  Navigator.pop(bContext);
                  final image = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _imageFile = image;
                    });
                    uploadImage();
                  } else {
                    if (!mounted) return;
                    SnackBarUtils.showSnackbar(
                      context: context,
                      message: 'No image selected',
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
