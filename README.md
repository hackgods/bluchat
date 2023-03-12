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
