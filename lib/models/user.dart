import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String token;
  final String credentialsAccessKeyId;
  final String credentialsSessionToken;
  final String credentialsSecretAccessKey;
  final String cloudOrigin;
  // final String password;
  // User({@required this.id, @required this.email, @required this.password});
  User(
      {@required this.id,
      @required this.email,
      @required this.token,
      this.credentialsAccessKeyId,
      this.credentialsSecretAccessKey,
      this.credentialsSessionToken,
      this.cloudOrigin});
}
