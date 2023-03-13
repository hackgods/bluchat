# bluechat

A new Flutter project.

## RsaUtils
```dart
import 'package:bluechat/functions/rsautils.dart';



RsaUtils rsautils=new RsaUtils();

// Generate Keypair
await rsautils.genKey();
print(rsautils.pk);
print(rsautils.sk);

// Encryption
String a=await rsautils.encryptMsg("fuck you in the ass");
print("encrypted message: $a");

// Decryption
String b=await rsautils.decryptMsg(a);
print("decrypted message: $b");
```


## secret key generate and aes
```dart
EncryptUtil eu1=EncryptUtil();
EncryptUtil eu2=EncryptUtil();
await eu1.gk();
await eu2.gk();

//exchange publickey, publickey is safe to send through air
await eu1.ss(await eu2.aliceKeyPair.extractPublicKey());
await eu2.ss(await eu1.aliceKeyPair.extractPublicKey());

String test='fuck you dip shit';

print("shared secret the same?  \n ss1 ${await eu1.sk.extractBytes()} \n ss2 ${await eu2.sk.extractBytes()}");

SecretBox box1=await eu1.enc(test.codeUnits,eu1.sk);
print("encrypt test: ${box1.cipherText}");
List<int> Plaintext=await eu2.dec(box1, eu2.sk);
print("decrypt test: ${new String.fromCharCodes(Plaintext)}");
```
