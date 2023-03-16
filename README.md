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

## serialize data to send
```dart
//hackgods call ppk to parse lucas.pk 
await hackgods.ppk((await lucas.pk()));

//pack encrypted into json string
String packed=SecretBag.Pack(box1);
print("String to send: ${packed.runtimeType} ${packed}");

//parse json string into encrypted SecretBox 
SecretBox box2=SecretBag.unPack(packed);
print(box2);
print("recv and dec: ${await hackgods.dec(box2)}");
```



## main
```dart
EncryptUtil lucas=EncryptUtil();

await lucas.gk();

//hackgods call hackgods.pk() send it to lucas
await lucas.ss(await lucas.ppk((hackgods.pk()));

String test='some plain text message';

String packed=SecretBag.Pack(await lucas.enc(test));
//send packed String to hackgods

// hackgods call await hackgods.dec(SecretBag.unPack(packed)) then gets the plaintext
```