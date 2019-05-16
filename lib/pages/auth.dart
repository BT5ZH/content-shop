import 'package:flutter/material.dart';

// import './videos.dart';
// import './videos_admin.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_model/sc_main.dart';
import '../models/auth.dart';
import '../models/cloud_origin.dart';
import '../widgets/ui/adaptive_progress_indicator.dart';
// enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final Map<String, dynamic> _formConfirmData = {
    'email': null,
    'confirmCode': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyConfirm = GlobalKey<FormState>();
  final TextEditingController _passTextController = TextEditingController();
  final TextEditingController _emailConfirmController = TextEditingController();
  final TextEditingController _codeConfirmController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;
  CloudOrigin _cloud = CloudOrigin.FB;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  String _selectItemValue = '选择云服务商';
  // List<DropdownMenuItem> generateItemList() {
  //   // return items;
  // }
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        // colorFilter: ColorFilter.mode(
        //     Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/images/background.jpeg'),
      ),
    );
  }

  // Widget _buildEmail(_emailValue){
  //   return TextField(
  //                 decoration: InputDecoration(labelText: '用户名'),
  //                 keyboardType: TextInputType.emailAddress,
  //                 onChanged: (String value) {
  //                   setState(() {
  //                     _emailValue = value;
  //                   });
  //                 },
  //               );
  // }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  // Widget _buildPass(_passwordValue){
  //   return TextField(
  //                 decoration: InputDecoration(labelText: '密码'),
  //                 obscureText: true,
  //                 onChanged: (String value) {
  //                   setState(() {
  //                     _passwordValue = value;
  //                   });
  //                 },
  //               );
  // }
  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      controller: _passTextController,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Confirm Password',
              filled: true,
              fillColor: Colors.white),
          // keyboardType: TextInputType.emailAddress,
          obscureText: true,
          validator: (String value) {
            if (_passTextController == value && _authMode == AuthMode.Signup) {
              return '密码错误';
            }
          },
        ),
      ),
    );
  }

  // Widget _buildSwich(){
  //   return SwitchListTile(
  //                 value: false,
  //                 onChanged: (bool value) {},
  //                 title: Text(
  //                   '接受协议',
  //                 ),
  //               );
  // }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  Widget _buildDropDown() {
    // String itemValue;
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem item1 =
        new DropdownMenuItem(value: 'firebase', child: new Text('谷歌云'));
    DropdownMenuItem item2 =
        new DropdownMenuItem(value: 'aws', child: new Text('亚马逊云'));
    items.add(item1);
    items.add(item2);
    Widget hintText = new Text(
      _selectItemValue,
      style: TextStyle(color: Colors.white),
    );
    return DropdownButton(
      hint: hintText,
      // value: selectItemValue,
      items: items,
      onChanged: (val) {
        String temp = '';
        if (val == 'firebase') {
          // itemValue=val;
          temp = '谷歌云';
          _cloud = CloudOrigin.FB;
        } else if (val == 'aws') {
          // itemValue=val;
          temp = '亚马逊云';
          _cloud = CloudOrigin.AWS;
        }
        setState(() {
          _selectItemValue = temp;
        });
        print('====== $_cloud');
      },
    );
  }

  Widget _buildConfirmationArea() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Confirm Email',
              filled: true,
              fillColor: Colors.white),
          controller: _emailConfirmController,
          // obscureText: true,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return '格式有误';
            }
          },
          onSaved: (String value) {
            _formConfirmData['confirmEmail'] = value;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Confirmation Code',
              filled: true,
              fillColor: Colors.white),
          controller: _codeConfirmController,
          // obscureText: true,
          validator: (String value) {
            if (value.isEmpty || value.length < 6) {
              return '格式有误';
            }
          },
          onSaved: (String value) {
            _formConfirmData['confirmCode'] = value;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        // FlatButton(child: Text('确认'),onPressed: (){

        // },)
        ScopedModelDescendant<SCMainModel>(
          builder: (BuildContext context, Widget child, SCMainModel model) {
            return 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              model.isLoading
                ? AdaptiveProgressIndicator()
                : RaisedButton(
                    textColor: Colors.white,
                    child: Text('获取验证码'),
                    onPressed: () {
                      if (_cloud == CloudOrigin.FB) {
                        _resendConfirmCode(model.authenticateFB);
                      } else if (_cloud == CloudOrigin.AWS) {
                        _resendConfirmCode(model.authenticateAWS);
                      }
                    }),
              model.isLoading
                ? AdaptiveProgressIndicator()
                : RaisedButton(
                    textColor: Colors.white,
                    child: Text('确认'),
                    onPressed: () {
                      if (_cloud == CloudOrigin.FB) {
                        _submitConfirmForm(model.authenticateFB);
                      } else if (_cloud == CloudOrigin.AWS) {
                        _submitConfirmForm(model.authenticateAWS);
                      }
                    }),
            ],);
            
          },
        ),
      ],
    );
  }

  void _submitForm(Function authenticate) async {
    //Function login, Function signup
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInfomation;
    // if (_authMode == AuthMode.Login) {
    successInfomation = await authenticate(
        _formData['email'], _formData['password'], _authMode, _cloud);
    // } else {
    //   successInfomation =
    //       await signup(_formData['email'], _formData['password']);}
    print(successInfomation);
    _feedBackInfo(successInfomation);
  }

  void _submitConfirmForm(Function authenticate) async {
    if (!_formKeyConfirm.currentState.validate()) {
      //|| !_formData['acceptTerms']
      return;
    }
    _formKeyConfirm.currentState.save();
    Map<String, dynamic> successInfomation;
    successInfomation = await authenticate(_formConfirmData['email'],
        _formConfirmData['confirmCode'], _authMode, _cloud, 'true');
    _feedBackInfo(successInfomation);
  }

  void _resendConfirmCode(Function authenticate) async {
    if (_emailConfirmController.text==null && _emailConfirmController.text=='') {
      return;
    }
    // _formKeyConfirm.currentState.save();
    Map<String, dynamic> successInfomation;
    successInfomation = await authenticate(_formConfirmData['email'],'',
         _authMode, _cloud, 'send');
    _feedBackInfo(successInfomation);
  }

  void _feedBackInfo(Map successInfomation) {
    if (successInfomation['success'] == true) {
      // Navigator.pushReplacementNamed(context, '/');
      //contents
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('出错了'),
              content: Text(successInfomation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        bottomOpacity: 0.5,
      ),
      body: Container(
        decoration: _buildBackgroundImage(),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          // _authMode == AuthMode.Signup
                          //     ? _buildConfirmPasswordTextField()
                          //     : Container(),
                          _buildConfirmPasswordTextField(),
                          _buildAcceptSwitch(),
                          SizedBox(
                            height: 10.0,
                          ),
                          FlatButton(
                            child: Text(
                                'Switch to ${_authMode == AuthMode.Login ? 'signup' : 'login'}'),
                            onPressed: () {
                              if (_authMode == AuthMode.Login) {
                                setState(() {
                                  _authMode = AuthMode.Signup;
                                });
                                _controller.forward();
                              } else {
                                setState(() {
                                  _authMode = AuthMode.Login;
                                });
                                _controller.reverse();
                              }

                              // _authMode = _authMode == AuthMode.Login
                              //     ? AuthMode.Signup
                              //     : AuthMode.Login;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ScopedModelDescendant<SCMainModel>(
                            builder: (BuildContext context, Widget child,
                                SCMainModel model) {
                              return model.isLoading
                                  ? AdaptiveProgressIndicator()
                                  : RaisedButton(
                                      textColor: Colors.white,
                                      child: Text(_authMode == AuthMode.Login
                                          ? 'LOGIN'
                                          : 'SINGUP'),
                                      onPressed: () {
                                        if (_cloud == CloudOrigin.FB) {
                                          _submitForm(model.authenticateFB);
                                        } else if (_cloud == CloudOrigin.AWS) {
                                          _submitForm(model.authenticateAWS);
                                        }
                                      }, //model.login, model.signup
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKeyConfirm,
                      child: Column(
                        children: <Widget>[
                          _authMode == AuthMode.Login
                              ? Text('')
                              : _buildConfirmationArea(),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                    _buildDropDown(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
