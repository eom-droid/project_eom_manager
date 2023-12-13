import 'package:manager/auth/model/token_model.dart';
import 'package:manager/user/model/user_model.dart';

abstract class UserWithTokenModelBase {}

class UserWithTokenModelError extends UserWithTokenModelBase {
  final String message;

  UserWithTokenModelError({
    required this.message,
  });
}

class UserWithTokenModelLoading extends UserWithTokenModelBase {}

class UserWithTokenModel extends UserWithTokenModelBase {
  final UserModel user;
  final TokenModel token;

  UserWithTokenModel({
    required this.user,
    required this.token,
  });
}
