import 'dart:io';

enum AuthMode {
  signIn,
  signUp,
}

final usernameRegExp = RegExp(r'^[\w.@+-]+$');
final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}"
    r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
// TODO : title regex

class ErrorMessages {
  static const invalidCred = "Invalid Credentials!";
  static const someError = "Some Error Occured";
  static String getErrorMessage(Exception e) {
    if (e is SocketException) {
      return "No Internet Connection";
    }
    return e.toString();
  }
}
