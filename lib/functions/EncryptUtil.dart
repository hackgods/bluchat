import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dummycastle/pl/polinc/dummycastle/dummycastle.dart';


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

  //generate keypair
  gk() async {
    aliceKeyPair=await X25519().newKeyPair();
  }

  //pack public key into json string
  pk() async{
    return base64Encode((await aliceKeyPair.extractPublicKey()).bytes);
  }

  //parse public key from json string
  ppk(String pkstr) async{
    List pkl=base64Decode(pkstr);
    return SimplePublicKey(pkl.cast<int>(), type: KeyPairType.x25519);
  }

  //derive secret key from peers public key
  ss(PublicKey bobPublicKey) async {

      sk = await X25519().sharedSecretKey(
      keyPair: aliceKeyPair,
      remotePublicKey: bobPublicKey,
    );
  }

  //derive new secret key from old key, set a interval call, whoever initiated the session tell the peer to generate new key , sync sss call
  sss() async {
    final algorithm = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    );
    final nonce = [4,5,6];
    final output = await algorithm.deriveKey(
      secretKey: sk,
      nonce: nonce,
    );
    sk=SecretKey(output.bytes);
  }

  //aes ctr 256 bits encryption
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

  //aes ctr 256 bits decryption
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
