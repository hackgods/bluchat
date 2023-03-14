
import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';



class EncryptUtil {

  late SimpleKeyPair aliceKeyPair;
  late SecretKey sk;

  gk() async {
    aliceKeyPair=await X25519().newKeyPair();
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
