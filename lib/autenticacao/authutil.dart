import '../main.dart';

class AuthUtil {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return null;
    return jwt;
  }
}