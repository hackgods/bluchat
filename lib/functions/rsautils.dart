import 'package:fast_rsa/fast_rsa.dart';

class RsaUtils{

  late String pk,sk;

  Future<int> genKey() async
  {
    KeyPair keyPair1 = await RSA.generate(2048);
    sk=await RSA.convertPrivateKeyToPKCS1(keyPair1.privateKey);
    pk=await RSA.convertPublicKeyToPKCS1(keyPair1.publicKey);
    return 1;
  }

   Future<String> encryptMsg(String message) async
  {
    String result = await RSA.encryptPKCS1v15(message,pk);
    return result;
  }

  Future<String> decryptMsg(String message) async
  {
    String result = await RSA.decryptPKCS1v15(message,sk);
    return result;
  }



}
