import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/sc_main.dart';
import '../../models/content.dart';
import '../../models/location_data.dart';
import '../../widgets/form_inputs/location.dart';
import '../../widgets/form_inputs/image.dart';
import '../../widgets/ui/adaptive_progress_indicator.dart';

class ContentCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContentCreatePageState();
  }
}

class _ContentCreatePageState extends State<ContentCreatePage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'episode_count': null,
    // 'image': 'assets/images/home_pro_6.jpg',
    'image': null,
    'location': null
  };
  // String _titleValue = '';
  // String _descriptionValue = '';
  // double _priceValue = 0.0;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Content content) {
    if (content == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (content != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = content.title;
    } else if (content != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (content == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }
    // _titleTextController.text=content==null?'':content.title;
    return TextFormField(
      decoration: InputDecoration(labelText: '标题'),
      // initialValue: content == null ? '' : content.title,
      validator: (String value) {
        if (value.isEmpty) {
          return '标题不能为空';
        }
      },
      controller: _titleTextController,
      onSaved: (String value) {
        // setState(() {
        _formData['title'] = value;
        // });
      },
    );
  }

  Widget _buildDescriptionTextField(Content content) {
    if (content == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (content != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = content.description;
    }

    return TextFormField(
      maxLines: 6,
      decoration: InputDecoration(labelText: '内容描述'),
      // initialValue: content == null ? '' : content.description,
      controller: _descriptionTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return '详情不能为空或少于10个字母';
        }
      },
      onSaved: (String value) {
        // setState(() {
        _formData['description'] = value;
        // });
      },
    );
  }

  Widget _buildPriceTextField(Content content) {
    if (content == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (content != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = content.price.toString();
    }
    return TextFormField(
      decoration: InputDecoration(labelText: '内容价格'),
      // initialValue: content == null ? '' : content.price.toString(),
      controller: _priceTextController,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return '价格不为空，确保输入为数字';
        }
      },
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      onSaved: (String value) {
        // setState(() {
        _formData['price'] = double.parse(value);
        // });
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Content content) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: targetWidth,
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              _buildTitleTextField(content),
              _buildDescriptionTextField(content),
              _buildPriceTextField(content),
              SizedBox(
                height: 10.0,
              ),
              LocationInput(_setLocation, content),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, content),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<SCMainModel>(
      builder: (BuildContext context, Widget child, SCMainModel model) {
        // print('创建内容页面 [_buildSubmitButton] : ${model.selectedContentIndex}');
        // print('创建内容页面 [_buildSubmitButton] : ${model.addContent}');
        // print('创建内容页面 [_buildSubmitButton] : ${model.updateContent}');
        // print('创建内容页面 [_buildSubmitButton] : ${model.selectContent}');

        return model.isLoading
            ? Center(
                child: AdaptiveProgressIndicator(),
              )
            : RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text('保存'),
                onPressed: () {
                  print(model.user.cloudOrigin);
                  print(model.cloudFlag);
                  if(model.user.cloudOrigin=='FB'){
                    _submitForm(
                    model.addContent,
                    model.updateContent,
                    model.selectContent,
                    model.selectedContentIndex);
                  }else{
                    _submitForm(
                    model.addContentAWS,
                    model.updateContentAWS,
                    model.selectContent,
                    model.selectedContentIndex);
                  }
                  },
              );
      },
    );
  }

  void _setLocation(LocationDataModel locData) {
    _formData['location'] = locData;
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(
      Function addContent, Function updateContent, Function setSelectedContent,
      [int selectedContentIndex]) {
    if (!_formkey.currentState.validate() ||
        (_formData['image'] == null && selectedContentIndex == -1)) {
      print(selectedContentIndex);
      print(_formData['image']);
      print(_formkey.currentState.validate());
      print('验证未通过');
      return;
    }
    _formkey.currentState.save();

    if (selectedContentIndex == -1) {
      //null
      addContent(
        _formData['id'],
        // _formData['title'],
        _titleTextController.text,
        // _formData['description'],
        _descriptionTextController.text,
        _formData['image'],
        // _formData['price'],
        double.parse(_priceTextController.text),
        _formData['location'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/') // /contents
              .then((_) => setSelectedContent(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('please try again'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      });
    } else {
      print('调用更新模块=========== : $selectedContentIndex');
      updateContent(
        _formData['id'],
        // _formData['title'],
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        double.parse(_priceTextController.text),
        _formData['location'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/') // contents
          .then((_) => setSelectedContent(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SCMainModel>(
      builder: (BuildContext context, Widget widget, SCMainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedContent);
        // print('列表内容页面 [_buildEditButton] : ${model.selectedContentIndex}');
        return model.selectedContentIndex == -1 //null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('管理'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
