# bluechat

A new Flutter project.

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


//if lucas tells hackgods to gen new key, then they sync action , lucas call lucas.sss() and hackgods do the same 
```