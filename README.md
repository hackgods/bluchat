# bluechat

A new Flutter project.


## secret key generation and aes encryption
```dart
//on each side, have one encrypt utils
EncryptUtil lucas=EncryptUtil();
EncryptUtil hackgods=EncryptUtil();
//call gk to generate keypair
//if old keys cannot be trusted, should call this again and generate new secret key
await lucas.gk();
await hackgods.gk();

//serialize publickey and send it to hackgods 
//lucas pass hackgods' publickey to func ss to generate secret key
await lucas.ss(await hackgods.aliceKeyPair.extractPublicKey());
//serialize publickey and send it to lucas
//hackgods pass lucas' publickey to func ss to generate secret key
await hackgods.ss(await lucas.aliceKeyPair.extractPublicKey());
//up to this point, lucas and hackgods have the same secret key

String test='some plain text message';

//lucas encrypt test message 
//lucas serialize SecretBox and send it to hackgods
SecretBox box1=await lucas.enc(test);
print("encrypt test: ${box1.cipherText}");

//hackgods recieve the Secretbox and unserialize it then decrypt the message
String Plaintext=await hackgods.dec(box1);
print("decrypt test: $Plaintext");
```
