final String userTable = 'userTable';

class userModel {
  static final List<String> values = [

    id,username,deviceID,profilePhoto
  ];

  static final String id = '_id';
  static final String username = 'username';
  static final String deviceID = 'deviceID';
  static final String profilePhoto = 'profilePhoto';

}

class User {
  final int? id;
  final String username;
  final String deviceID;
  final int profilePhoto;

  const User({
    this.id,
    required this.username,
    required this.deviceID,
    required this.profilePhoto,

  });

  User copy({
    int? id,
    String? username,
    String? deviceID,
    int? profilePhoto,

  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
          deviceID: deviceID ?? this.deviceID,
        profilePhoto: profilePhoto ?? this.profilePhoto,

      );

  static User fromJson(Map<String, Object?> json) => User(
    id: json[userModel.id] as int?,
    username: json[userModel.username] as String,
      deviceID: json[userModel.deviceID] as String,
    profilePhoto: json[userModel.profilePhoto] as int,

  );

  Map<String, Object?> toJson() => {
    userModel.id: id,
    userModel.username: username,
    userModel.deviceID: deviceID,
    userModel.profilePhoto: profilePhoto
  };
}