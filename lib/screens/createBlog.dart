import '../widget/bottombar.dart';

import '../widget/imagePick.dart';
import 'package:image_picker/image_picker.dart';

import '../models/blog.dart';
import 'dart:io';
import '../providers/blog.dart';
import '../screens/HomeScreen.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class CreateBlog extends StatefulWidget {
  static const routeName = 'create-blog';
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  final _bodyFocus = FocusNode();
  var uuid = Uuid();
  String _cover;
  File _coverFile;
  bool fileisnull = true;
  final _form = GlobalKey<FormState>();
  var _newBlog = BlogModel(
      body: '',
      id: null,
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
      image: '',
      title: '');
  bool _isInit = true;
  bool _isloading = false;
  bool cameraPicLoading = false;
  var _initValues = {
    'title': '',
    'body': '',
    'image': '',
    'date': DateTime,
  };

  Future getImage(FilePickerResult pickedFile) async {
    String pathof = await _localPath;

    fileisnull = false;
    setState(() {
      if (pickedFile.files != null) {
        PlatformFile fileUploaded = pickedFile.files.first;
        _coverFile = File(fileUploaded.path);
        String filePos =
            pathof + "/" + "blogid-" + uuid.v4() + fileUploaded.name;
        _coverFile.copy(filePos);
        _newBlog = BlogModel(
            id: _newBlog.id,
            title: _newBlog.title,
            body: _newBlog.body,
            image: filePos.toString(),
            date: _newBlog.date);
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveForm() {
    _cover = "";
    if (_cover == null) {
      _cover = '';
    }
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isloading = true;
      });
      if (_newBlog.id != null) {
        Provider.of<Blogs>(context, listen: false)
            .updateBlog(_newBlog.id, _newBlog)
            .then((value) => {
                  setState(() {
                    _isloading = false;
                  }),
                  Navigator.of(context).popAndPushNamed(HomeScreen.routeName),
                });
      } else {
        Provider.of<Blogs>(context, listen: false).addBlog(_newBlog).then((_) =>
            {
              _isloading = false,
              Navigator.of(context).popAndPushNamed(HomeScreen.routeName)
            });
      }
    }
    return;
  }

  @override
  void dispose() {
    _bodyFocus.dispose();
    super.dispose();
  }

  void didChangeDependencies() {
    if (_isInit) {
      final blogid = ModalRoute.of(context).settings.arguments as String;
      if (blogid != null) {
        _newBlog = Provider.of<Blogs>(context, listen: false)
            .findByID(int.parse(blogid));
        if (_newBlog.image != null || _newBlog.image != '') {
          fileisnull = false;
          _coverFile = File(_newBlog.image);
        } else {
          fileisnull = true;
        }
        _initValues = {
          'title': _newBlog.title,
          'body': _newBlog.body,
          'image': _newBlog.image,
          'date': _newBlog.date.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      'Please select Camera Or Gallery',
                      style: TextStyle(fontSize: 18),
                    )),
                  ),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Gallery'),
                      onTap: () async {
                        FilePickerResult pickedFile =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.image,
                        );
                        getImage(pickedFile);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      final File image = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      String pathof = await _localPath;
                      setState(() {
                        if (image != null) {
                          cameraPicLoading = true;
                          _coverFile = image;
                          String filePos = pathof +
                              "/" +
                              "blogid-" +
                              uuid.v4() +
                              'Cover.jpg';
                          fileisnull = false;
                          _coverFile.copy(filePos).then((value) => {
                                cameraPicLoading = false,
                              });

                          _newBlog = BlogModel(
                              id: _newBlog.id,
                              title: _newBlog.title,
                              body: _newBlog.body,
                              image: filePos.toString(),
                              date: _newBlog.date);
                        } else {
                          print('No image selected.');
                        }
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Create Blog",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        OutlineButton.icon(
                            onPressed: () => showPicker(context),
                            highlightedBorderColor: Colors.blue,
                            clipBehavior: Clip.antiAlias,
                            icon: Icon(Icons.file_upload),
                            color: Colors.pink,
                            padding: EdgeInsets.all(18),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            label: Text(
                              "Upload Blog Cover",
                              style: TextStyle(color: Colors.pink),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          constraints:
                              BoxConstraints(maxHeight: 100, minWidth: 50),
                          child: fileisnull
                              ? Center(
                                  child: Text("Selected Image Will Show Here"))
                              : cameraPicLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Image.file(
                                      _coverFile,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          maxLength: 50,
                          maxLengthEnforced: true,
                          initialValue: _initValues['title'],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          autocorrect: true,
                          onSaved: (value) {
                            _newBlog = BlogModel(
                                id: _newBlog.id,
                                title: value,
                                body: _newBlog.body,
                                image: _newBlog.image,
                                date: _newBlog.date);
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.pink, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              alignLabelWithHint: true,
                              labelText: "Title",
                              hintText: "Title Of Blog",
                              hintStyle: TextStyle(color: Colors.pink),
                              contentPadding: EdgeInsets.all(20)),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_bodyFocus);
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          initialValue: _initValues['body'],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _newBlog = BlogModel(
                                id: _newBlog.id,
                                title: _newBlog.title,
                                body: value,
                                image: _newBlog.image,
                                date: _newBlog.date);
                          },
                          autocorrect: true,
                          maxLines: 10,
                          decoration: InputDecoration(
                              fillColor: Colors.black12,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.pink, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              alignLabelWithHint: true,
                              labelText: "Body",
                              hintText: "Body Of Blog",
                              hintStyle: TextStyle(color: Colors.pink),
                              contentPadding: EdgeInsets.all(15)),
                          keyboardType: TextInputType.multiline,
                          focusNode: _bodyFocus,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            _saveForm();
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.pink,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
