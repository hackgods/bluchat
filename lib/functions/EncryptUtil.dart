
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


  Future<SecretBox> enc(List<int> message, SecretKey secretKey) async {

    AesCtr algorithm = AesCtr.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final nonce = algorithm.newNonce();
    final secretBox = await algorithm.encrypt(
      message,
      secretKey: secretKey,
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


  Future<List<int>> dec(SecretBox encrypted, SecretKey secretKey) async {
    AesCtr algorithm = AesCtr.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    List<int> decrypted = await algorithm.decrypt(
      encrypted,
      secretKey: secretKey,
    );
    return decrypted;
  }



}
