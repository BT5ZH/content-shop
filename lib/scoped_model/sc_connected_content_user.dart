import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
// import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';
import 'package:async/async.dart';

import '../models/content.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/cloud_origin.dart';
import '../models/location_data.dart';
import '../models/policy.dart';
import '../global/global_config.dart';

mixin SCConnectedContentUserModel on Model {
  List<Content> _contents = [];
  // int _selContentIndex;
  String _selContentId;
  User _authenticatedUser;
  bool _isLoading = false;
}

mixin SCContentsModel on SCConnectedContentUserModel {
  bool _showFavorites = false;

  List<Content> get allContents {
    return List.from(_contents);
  }

  List<Content> get displayedContents {
    if (_showFavorites) {
      return _contents.where((Content content) => content.isFavorite).toList();
    }
    return List.from(_contents);
  }

  // int get selectedContentIndex {
  //   return _selContentIndex;
  // }

  String get selectedContentId {
    return _selContentId;
  }

  Content get selectedContent {
    if (selectedContentId == null) {
      return null;
    }
    // return _contents[selectedContentId];
    return _contents.firstWhere((Content content) {
      return content.id == selectedContentId;
    });
  }

  int get selectedContentIndex {
    return _contents.indexWhere((Content content) {
      return content.id == _selContentId;
    });
  }

  bool get displayFavirotesOnly {
    return _showFavorites;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-content-shop-8f405.cloudfunctions.net/storeImage'));
    print(Uri.parse('uri'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    print(file);
    print(image.path);
    print(mimeTypeData[0]);
    print(mimeTypeData[1]);
    print(_authenticatedUser.token);

    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
      print(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('出错了');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Map<String, dynamic>> uploadImageAWS(File image,
      {String imagePath}) async {
    Map<String, dynamic> result;
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final List<String> imageContentPath = image.path.split('/');
    String imageContentName = imageContentPath[imageContentPath.length - 1];
    final List<String> trimName = imageContentName.split('_');
    String lastWord = trimName[trimName.length - 1];
    String imagePath2;
    String imageUrl;
    String tempPath = 'Users/firstTest/';
    imagePath2 = tempPath + lastWord;
    imageUrl = baseUrl + bucketName + '/' + imagePath2;
    // print(lastWord);

    const _region = 'us-east-2';
    const String _s3Endpoint =
        'https://s3-us-east-2.amazonaws.com/chunk-shop-bucket';

    final file = File(image.path);

    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();

    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(_s3Endpoint));

    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path),
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    final policy = Policy.fromS3PresignedPost(
        'Users/firstTest/$lastWord',
        'chunk-shop-bucket',
        15 * 1024,
        _authenticatedUser.credentialsAccessKeyId,
        length,
        _authenticatedUser.credentialsSessionToken,
        region: _region);
    final key = SigV4.calculateSigningKey(
        _authenticatedUser.credentialsSecretAccessKey,
        policy.datetime,
        _region,
        's3');
    final signature = SigV4.calculateSignature(key, policy.encode());
    imageUploadRequest.files.add(multipartFile);

    // final credentialScope = SigV4.buildCredentialScope(policy.datetime, _region, 's3');
    // final stringTosign = SigV4.buildStringToSign(policy.datetime, credentialScope, hashedCanonicalRequest);
    // var temp = mimeTypeData[0]+'/'+mimeTypeData[0]
    imageUploadRequest.fields['key'] = policy.key;
    imageUploadRequest.fields['acl'] = 'public-read';
    imageUploadRequest.fields['X-Amz-Credential'] = policy.credential;
    imageUploadRequest.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    imageUploadRequest.fields['X-Amz-Date'] = policy.datetime;
    imageUploadRequest.fields['content-type'] =
        '${mimeTypeData[0]}/${mimeTypeData[1]}';
    imageUploadRequest.fields['Policy'] = policy.encode();
    imageUploadRequest.fields['X-Amz-Signature'] = signature;
    imageUploadRequest.fields['x-amz-security-token'] =
        _authenticatedUser.credentialsSessionToken;

    http.StreamedResponse response;
    String message;

    try {
      response = await imageUploadRequest.send();

      if (response.statusCode == 204) {
        result = {
          'success': true,
          'message': 'upload success',
          'imagePath': imagePath2,
          'imageUrl': imageUrl
        };
      }
      print('1111111111111');
    } catch (e) {
      print('22222');
      print(e.toString());
      await for (var value in response.stream.transform(utf8.decoder)) {
        print(value);
      }
    }
    return result;
  }

  Future<bool> addContent(String id, String title, String description,
      File image, double price, LocationDataModel locData) async {
    _isLoading = true;
    notifyListeners();

    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('上传失败');
      return false;
    }

    final Map<String, dynamic> contentData = {
      'title': title,
      'description': description,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
    };
    return http
        .post(
            'https://content-shop-8f405.firebaseio.com/contents.json?auth=${_authenticatedUser.token}',
            body: json.encode(contentData))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        final Content newContent = Content(
            id: responseData['name'],
            title: title,
            description: description,
            price: price,
            image: uploadData['imageUrl'],
            imagePath: uploadData['imagePath'],
            location: locData,
            userEmail: _authenticatedUser.email,
            userId: _authenticatedUser.id);
        _contents.add(newContent);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> addContentAWS(String id, String title, String description,
      File image, double price, LocationDataModel locData) async {
    var uuid = new Uuid();
    var itemId = uuid.v4();
    _isLoading = true;
    notifyListeners();

    final uploadData = await uploadImageAWS(image);
    if (uploadData == null) {
      print('上传失败');
      _isLoading = false;
      notifyListeners();
      return false;
    }
    final Map<String, dynamic> locationData = {
      'latitude': locData.latitude,
      'longitude': locData.longitude,
      'address': locData.address
    };
    final Map<String, dynamic> contentData = {
      'id': itemId,
      'title': title,
      'description': description,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'isFavorite': false,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'location': locationData
    };

    // final String _localRegion='us-east-2';
    // final awsSigV4Client = new AwsSigV4Client(
    //   _authenticatedUser.credentialsAccessKeyId, _authenticatedUser.credentialsSecretAccessKey, _endPointForAdd,
    //   sessionToken: _authenticatedUser.credentialsSessionToken,
    //   region: _localRegion);
    // final signedRequest = new SigV4Request(awsSigV4Client,
    //   method: 'POST',
    //   path: '/chunk-shop',
    //   body: new Map<String, dynamic>.from(contentData));

    http.Response response;

    final String simpleUrl =
        'https://mkev0ivepk.execute-api.us-east-2.amazonaws.com/dev-cs/chunk-shop';

    final Map<String, String> headerString = {
      'Content-Type': 'application/json',
      'Authorization': 'allow'
    };

    try {
      // response = await http.post(signedRequest.url, headers: signedRequest.headers, body: signedRequest.body);
      response = await http.post(simpleUrl,
          headers: headerString, body: json.encode(contentData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      } else {
        final Content newContent = Content(
            id: itemId,
            title: title,
            description: description,
            price: price,
            image: uploadData['imageUrl'],
            imagePath: uploadData['imagePath'],
            location: locData,
            userEmail: _authenticatedUser.email,
            userId: _authenticatedUser.id);
        _contents.add(newContent);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (error) {
      print(error.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateContent(
    String id,
    String title,
    String description,
    File image,
    double price,
    LocationDataModel locData,
  ) async {
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedContent.image;
    String imagePath = selectedContent.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('上传失败');
        return false;
      }
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': selectedContent.userEmail,
      'userId': selectedContent.userId,
    };
    return http
        .put(
            'https://content-shop-8f405.firebaseio.com/contents/${selectedContent.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      // print('模型页面 [updateContent] : ${selectedContent.id}');
      _isLoading = false;
      final Content updatedContent = Content(
          id: selectedContent.id,
          title: title,
          description: description,
          price: price,
          image: imageUrl,
          imagePath: imagePath,
          location: locData,
          userEmail: selectedContent.userEmail,
          userId: selectedContent.userId);
      // final int selectedContentIndex = _contents.indexWhere((Content content){
      //   return content.id==_selContentId;
      // });
      _contents[selectedContentIndex] = updatedContent;
      // _selContentIndex = null;
      print('可能又失去了连接     ： $selectedContentId');
      notifyListeners();
      return true;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateContentAWS(
    String id,
    String title,
    String description,
    File image,
    double price,
    LocationDataModel locData,
  ) async {}

  Future<bool> deleteContent() {
    _isLoading = true;
    final deletedContentId = selectedContent.id;
    // final int selectedContentIndex = _contents.indexWhere((Content content){
    //       return content.id==_selContentId;
    //     });
    _contents.removeAt(selectedContentIndex);
    // _selContentIndex = null;
    _selContentId = null;
    notifyListeners();
    return http
        .delete(
            'https://content-shop-8f405.firebaseio.com/contents/$deletedContentId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteContentAWS() {
    _isLoading = true;
    final deletedContentId = selectedContent.id;
    _contents.removeAt(selectedContentIndex);
    _selContentId = null;
    notifyListeners();
    final Map<String, String> headerString = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'allow'
    };
    var queryParameters = {
      'param1': deletedContentId,
      'param2': _authenticatedUser.id,
    };
    var uri = Uri.https('mkev0ivepk.execute-api.us-east-2.amazonaws.com',
        '/dev-cs/chunk-shop', queryParameters);

    return http
        .delete(uri, headers: headerString)
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> fetchContents({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _contents = [];
    }

    notifyListeners();
    return http
        .get(
            'https://content-shop-8f405.firebaseio.com/contents.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Content> fetchedContentList = [];
      final Map<String, dynamic> contentsList = json.decode(response.body);
      if (contentsList == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      contentsList.forEach((String key, dynamic contentData) {
        final Content content = Content(
          id: key,
          title: contentData['title'],
          description: contentData['description'],
          price: contentData['price'],
          location: LocationDataModel(
              address: contentData['loc_address'],
              latitude: contentData['loc_lat'],
              longitude: contentData['loc_lng']),
          // image: contentData['image'],
          image: contentData['imageUrl'],
          imagePath: contentData['imagePath'],
          userEmail: contentData['userEmail'],
          userId: contentData['userId'],
          isFavorite: contentData['wishlistUsers'] == null
              ? false
              : (contentData['wishlistUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id),
        );
        fetchedContentList.add(content);
      });
      print(json.decode(response.body));
      _contents = onlyForUser
          ? fetchedContentList.where((Content content) {
              return content.userId == _authenticatedUser.id;
            }).toList()
          : fetchedContentList;
      _isLoading = false;
      notifyListeners();
      _selContentId = null;
    }).catchError((onError) {
      _isLoading = false;
      notifyListeners();
      return; //false
    });
  }

  Future<bool> fetchContentsAWS({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _contents = [];
    }
    notifyListeners();
    final String simpleUrl =
        'https://mkev0ivepk.execute-api.us-east-2.amazonaws.com/dev-cs/chunk-shop/all';

    final Map<String, String> headerString = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'allow'
    };
    return http
        .get(simpleUrl, headers: headerString)
        .then<Null>((http.Response response) {
      final List<Content> fetchedContentList = [];
      print('${response.body}');
      print('${json.decode(response.body)}');
      // final Map<String, dynamic> contentsList= json.decode(response.body);
      final List<dynamic> contentsList = json.decode(response.body);
      if (contentsList == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      // contentsList.forEach((String key, dynamic contentData) {
      contentsList.forEach((dynamic contentData) {
        final Content content = Content(
          id: contentData['id'],
          title: contentData['title'],
          description: contentData['description'],
          price: double.parse(contentData['price']),
          location: LocationDataModel(
              address: contentData['loc_address'],
              latitude: double.parse(contentData['loc_lat']),
              longitude: double.parse(contentData['loc_lng'])),
          // image: contentData['image'],
          image: contentData['imageUrl'],
          imagePath: contentData['imagePath'],
          userEmail: contentData['userEmail'],
          userId: contentData['userId'],
          isFavorite: contentData['wishlistUsers'] == null
              ? false
              : (contentData['wishlistUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id),
        );
        fetchedContentList.add(content);
      });
      print(json.decode(response.body));
      _contents = onlyForUser
          ? fetchedContentList.where((Content content) {
              return content.userId == _authenticatedUser.id;
            }).toList()
          : fetchedContentList;
      _isLoading = false;
      notifyListeners();
      _selContentId = null;
    }).catchError((onError) {
      print(onError.toString());
      _isLoading = false;
      notifyListeners();
      return; //false
    });
  }

  void toggleContentFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedContent.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    print(isCurrentlyFavorite);
    print(newFavoriteStatus);

    final Content updatedContent = Content(
        id: selectedContent.id,
        title: selectedContent.title,
        description: selectedContent.description,
        price: selectedContent.price,
        image: selectedContent.image,
        imagePath: selectedContent.imagePath,
        location: selectedContent.location,
        userEmail: selectedContent.userEmail,
        userId: selectedContent.userId,
        isFavorite: newFavoriteStatus);
    _contents[selectedContentIndex] = updatedContent;
    notifyListeners();

    http.Response response;
    if (newFavoriteStatus) {
      print(newFavoriteStatus);
      print(selectedContent.id);
      print(_authenticatedUser.id);
      response = await http.put(
          'https://content-shop-8f405.firebaseio.com/contents/${selectedContent.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: jsonEncode(true));
      print(json.decode(response.body));
    } else {
      response = await http.delete(
        'https://content-shop-8f405.firebaseio.com/contents/${selectedContent.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
      );
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('更新成功啦，去找找wishlistUser');
      final Content updatedContent = Content(
          id: selectedContent.id,
          title: selectedContent.title,
          description: selectedContent.description,
          price: selectedContent.price,
          image: selectedContent.image,
          imagePath: selectedContent.imagePath,
          location: selectedContent.location,
          userEmail: selectedContent.userEmail,
          userId: selectedContent.userId,
          isFavorite: !newFavoriteStatus);
      _contents[selectedContentIndex] = updatedContent;
      notifyListeners();
    }
    _selContentId = null;
  }

  // void selectContent(int index) {
  void selectContent(String contentId) {
    // _selContentIndex = index;
    _selContentId = contentId;
    if (contentId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin SCUserModel on SCConnectedContentUserModel {
  Timer authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();
  String cloudFlag;

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticateFB(String email, String password,
      [AuthMode mode = AuthMode.Login,
      CloudOrigin cloud = CloudOrigin.FB,
      bool confirmFlag = false]) async {
    print('手动登陆方法被执行');
    cloudFlag = "FB";
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    Map<String, dynamic> responseData;
    String message = 'something went wrong';
    bool hasError = true;

    if (cloud == CloudOrigin.FB) {
      try {
        if (mode == AuthMode.Login) {
          response = await http.post(
              'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBAH1IySCVMl6AuK7xX9EZQU54pWGdDVMI',
              body: json.encode(authData),
              headers: {'Content-Type': 'application/json'});
        } else {
          response = await http.post(
              'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBAH1IySCVMl6AuK7xX9EZQU54pWGdDVMI',
              body: json.encode(authData),
              headers: {'Content-Type': 'application/json'});
        }
        responseData = json.decode(response.body);
      } catch (err) {
        print(err);
        return {'success': 'false', 'message': err};
      }

      if (responseData.containsKey('idToken')) {
        print('登陆成功');
        hasError = false;
        message = 'Authentication succeeded';
        _authenticatedUser = User(
            id: responseData['localId'],
            email: email,
            token: responseData['idToken'],
            cloudOrigin: 'FB');
        setAuthTimeout(int.parse(responseData['expiresIn']));
        _userSubject.add(true);

        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', responseData['idToken']);
        pref.setString('userEmail', email);
        pref.setString('userId', responseData['localId']);
        pref.setString('expiryTime', expiryTime.toIso8601String());
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        message = '该邮件地址已经被注册';
        print('该邮件地址已经被注册');
      } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        message = '该邮件地址不存在';
        print('该邮件地址不存在');
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        message = '用户名或密码有误';
        print('用户名密码有误');
      }
      print(responseData);
      _isLoading = false;
      notifyListeners();
      return {'success': !hasError, 'message': message};
    }
  }

  Future<Map<String, dynamic>> authenticateAWS(String email, String password,
      [AuthMode mode = AuthMode.Login,
      CloudOrigin cloud = CloudOrigin.FB,
      String confirmFlag = 'false']) async {
    cloudFlag = "AWS";
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    if (mode == AuthMode.Login) {
      return signInAWS(authData, authData['email']);
    } else if (mode == AuthMode.Signup) {
      if (confirmFlag == 'false') {
        return signUpAWS(authData, authData['email']);
      } else if (confirmFlag == 'true') {
        return signUpConfirmAWS(authData, authData['email']);
      } else if (confirmFlag == 'send') {
        return refeatchAWS(authData['email']);
      }
    }
  }

  Future<Map<String, dynamic>> signInAWS(
      Map<String, dynamic> signInData, String xUsername) async {
    bool hasError = true;
    String message = 'something went wrong';

    final userPool = new CognitoUserPool(awsPoolId, awsClientId);
    final CognitoUser loginUser = new CognitoUser(xUsername, userPool);
    final AuthenticationDetails authDetails = new AuthenticationDetails(
        username: xUsername, password: signInData['password']);

    final _credentials = CognitoCredentials(awsIdentityPoolId, userPool);

    // await _credentials.
    CognitoUserSession userSession;
    try {
      userSession = await loginUser.authenticateUser(authDetails);
      await _credentials
          .getAwsCredentials(userSession.getIdToken().getJwtToken());
      // print(userSession.getIdToken().getJwtToken());
      // print(_credentials.accessKeyId);
      // print(_credentials.secretAccessKey);
      // print(_credentials.sessionToken);
    } on CognitoUserNewPasswordRequiredException catch (error) {
      // handle New Password challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserMfaRequiredException catch (error) {
      // handle SMS_MFA challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserSelectMfaTypeException catch (error) {
      // handle SELECT_MFA_TYPE challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserMfaSetupException catch (error) {
      // handle MFA_SETUP challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserTotpRequiredException catch (error) {
      // handle SOFTWARE_TOKEN_MFA challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserCustomChallengeException catch (error) {
      // handle CUSTOM_CHALLENGE challenge
      _isLoading = false;
      notifyListeners();
      print(error);
    } on CognitoUserConfirmationNecessaryException catch (error) {
      // handle User Confirmation Necessary
      _isLoading = false;
      notifyListeners();
      print(error);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      return {'success': hasError, 'message': message};
    }

    if (userSession.getIdToken().getJwtToken().isNotEmpty) {
      print('AWS登陆成功');
      int interal = 3600;
      hasError = false;
      message = 'AWS登陆成功: Authentication succeeded';
      Map<String, dynamic> idTokenPaylod =
          userSession.getIdToken().decodePayload();
      print(idTokenPaylod['sub']);
      _authenticatedUser = User(
          id: idTokenPaylod['sub'], //-----------------------TODO
          email: signInData['email'],
          token: userSession.getAccessToken().getJwtToken(),
          credentialsAccessKeyId: _credentials.accessKeyId,
          credentialsSecretAccessKey: _credentials.secretAccessKey,
          credentialsSessionToken: _credentials.sessionToken,
          cloudOrigin: 'AWS');
      setAuthTimeout(interal);
      _userSubject.add(true);

      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: interal));

      final SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('token', userSession.getAccessToken().getJwtToken());
      pref.setString('accessKeyId', _credentials.accessKeyId);
      pref.setString('secretAccessKey', _credentials.secretAccessKey);
      pref.setString('sessionToken', _credentials.sessionToken);
      pref.setString('userEmail', signInData['email']);
      pref.setString('userId', idTokenPaylod['sub']);
      pref.setString('expiryTime', expiryTime.toIso8601String());
    } else if (signInData['error']['message'] == 'EMAIL_EXISTS') {
      message = '该邮件地址已经被注册';
      print('该邮件地址已经被注册');
    } else if (signInData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = '该邮件地址不存在';
      print('该邮件地址不存在');
    } else if (signInData['error']['message'] == 'INVALID_PASSWORD') {
      message = '用户名或密码有误';
      print('用户名密码有误');
    }

    // print(session.getAccessToken().getJwtToken());
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> signUpAWS(
      Map<String, dynamic> signUpData, String xUsername) async {
    bool hasError = true;
    String message = 'something went wrong';
    final userPool = new CognitoUserPool(awsPoolId, awsClientId);
    CognitoUserPoolData data;
    final List<AttributeArg> userAttributes = [
      new AttributeArg(name: 'email', value: signUpData['email']),
    ];
    try {
      data = await userPool.signUp(xUsername, signUpData['password'],
          userAttributes: userAttributes);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      return {'success': hasError, 'message': error};
    }
    print(data.user);
    return {'success': !hasError, 'message': '注册成功'};
  }

  Future<Map<String, dynamic>> signUpConfirmAWS(
      Map<String, dynamic> confirmData, String xUsername) async {
    bool hasError = true;
    String message = 'something went wrong';
    final userPool = new CognitoUserPool(awsPoolId, awsClientId);
    final CognitoUser registUser = new CognitoUser(xUsername, userPool);
    bool registrationConfirmed = false;
    try {
      registrationConfirmed =
          await registUser.confirmRegistration(confirmData['password']);
    } on CognitoClientException catch (error) {
      if (error.code == 'ExpiredCodeException') {
        message = '验证码过期，请重新获取验证码';
      }
      _isLoading = false;
      notifyListeners();
      return {'success': hasError, 'message': message};
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      return {'success': hasError, 'message': error};
    }
    print('注册确认信息：$registrationConfirmed');
    return {'success': !hasError, 'message': '验证成功'};
  }

  Future<Map<String, dynamic>> refeatchAWS(String xUsername) async {
    bool hasError = true;
    String message = 'something went wrong';
    final userPool = new CognitoUserPool(awsPoolId, awsClientId);
    final CognitoUser registeredUser = new CognitoUser(xUsername, userPool);

    String status;
    try {
      status = await registeredUser.resendConfirmationCode();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      return {'success': hasError, 'message': error};
    }

    print('重新获取验证码信息：$status');
    return {'success': !hasError, 'message': '验证码已发送'};
  }

  void getAWSAuthenticatedUser() {}

  void logoutAWS() {}

  bool isAuthenticatedAWS() {
    return false;
  }

  void autoAuthenticate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token');
    final String expiryTimeString = pref.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = pref.getString('userEmail');
      final String userId = pref.getString('localId');
      final String userIdAWS = pref.getString('userId');
      final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;

      if (pref.containsKey('accessKeyId') &&
          pref.containsKey('secretAccessKey') &&
          pref.containsKey('sessionToken')) {
        _authenticatedUser = User(
            id: userIdAWS,
            email: userEmail,
            token: token,
            credentialsAccessKeyId: pref.getString('accessKeyId'),
            credentialsSecretAccessKey: pref.getString('secretAccessKey'),
            credentialsSessionToken: pref.getString('sessionToken'));
      } else {
        _authenticatedUser = User(id: userId, email: userEmail, token: token);
      }

      // _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logout() async {
    print('logout =========');
    _authenticatedUser = null;
    authTimer.cancel();
    _userSubject.add(false);
    _selContentId = null;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('userEmail');
    pref.remove('userId');
    // _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    // authTimer = Timer(Duration(milliseconds: time), logout);
    authTimer = Timer(Duration(seconds: time), logout
        // (){
        //   logout();
        //   _userSubject.add(false);
        // },
        );
  }
}

mixin UtilityModel on SCConnectedContentUserModel {
  bool get isLoading {
    return _isLoading;
  }
}
