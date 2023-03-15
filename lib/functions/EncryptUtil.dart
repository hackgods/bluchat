import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';


@JsonSerializable()
class SecretBag{

  static Map toJson(SecretBox box) => {
    'cipherText': box.cipherText,
    'mac': box.mac.bytes,
    'nonce': box.nonce
  };

  static fromJson(Map json) {
    //print("map: ${json['cipherText'].runtimeType}");
    List c=json['cipherText'];
    List m=json['mac'];
    List n=json['nonce'];

    //print("map:${c.toList()}");
    return SecretBox(c.cast<int>(),mac: Mac(m.cast<int>()),nonce:n.cast<int>() );
  }

  static String Pack(SecretBox box){
    return jsonEncode(toJson(box));
  }
  static SecretBox unPack(String bag){
    Map m=JsonDecoder().convert(bag);
    return fromJson(m);
  }
}



class EncryptUtil {

  late SimpleKeyPair aliceKeyPair;
  late SecretKey sk;

  gk() async {
    aliceKeyPair=await X25519().newKeyPair();
  }


  pk() async{
    return jsonEncode((await aliceKeyPair.extractPublicKey()).bytes);
  }
  ppk(String pkstr) async{
    List pkl=jsonDecode(pkstr);
    return SimplePublicKey(pkl.cast<int>(), type: KeyPairType.x25519);
  }

  ss(PublicKey bobPublicKey) async {

      sk = await X25519().sharedSecretKey(
      keyPair: aliceKeyPair,
      remotePublicKey: bobPublicKey,
    );
  }


  Future<SecretBox> enc(String message) async {

    AesCtr algorithm = AesCtr.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      message.codeUnits,
      secretKey: sk,
      nonce: nonce
    );
    //print('Nonce: ${secretBox.nonce}');
    //print('Ciphertext: ${secretBox.cipherText}');
    //print('MAC: ${secretBox.mac.bytes}');

    // Decrypt
    //final clearText = await algorithm.decrypt(
    //  secretBox,
    //  secretKey: secretKey,
    //);
    return secretBox;
  }


  Future<String> dec(SecretBox encrypted) async {
    AesCtr algorithm = AesCtr.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    List<int> decrypted = await algorithm.decrypt(
      encrypted,
      secretKey: sk,
    );
    return String.fromCharCodes(decrypted);
  }



}
