import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _picker = ImagePicker();

Future<FilePickerResult> _imgFromCamera() async {
  FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.image,
  );
  return pickedFile;
}

_imgFromGallery() async {
  final image =
      ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
}

showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
}
