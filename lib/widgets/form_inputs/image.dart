import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../../models/content.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Content content;
  ImageInput(this.setImage, this.content);
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.of(context);
    });
  }

  void _openImagePicker(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  '选择上传内容',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // SizedBox(
                //   height: 10.0,
                // ),
                FlatButton(
                  padding: EdgeInsets.all(5.0),
                  child: Text('拍照'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                // SizedBox(
                //   height: 5.0,
                // ),
                FlatButton(
                  padding: EdgeInsets.all(5.0),
                  child: Text('相册'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewImage = Text('请选择图片');
    if (_imageFile != null) {
      previewImage = Image.file(
        _imageFile,
        fit: BoxFit.cover,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    } else if (widget.content != null) {
      previewImage = Image.network(
        widget.content.image,
        fit: BoxFit.cover,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    }
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt),
              SizedBox(
                width: 5.0,
              ),
              Text('Add Image')
            ],
          ),
          onPressed: () {
            _openImagePicker(context);
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        previewImage,
        // _imageFile == null
        //     ? Text('请选择图片')
        //     :
      ],
    );
  }
}
