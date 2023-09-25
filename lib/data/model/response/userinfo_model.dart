class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  String isPhoneVerified;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String emailVerificationToken;
  String phone;
  String cmFirebaseToken;
  double point;
  String loginMedium;
  String referCode;


  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.referCode,
        this.point,
        this.cmFirebaseToken,
        this.loginMedium,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    point = json['point'] != null ? double.parse(json['point'] ): null;
    loginMedium = '${json['login_medium']}';
    referCode = '${json['refer_code']}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['phone'] = this.phone;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['point'] = this.point;
    data['login_medium'] = this.loginMedium;
    data['refer_code'] = this.referCode;
    return data;
  }
}


///new
// import 'dart:convert';
//
// UserInfoModel userInfoModelFromJson(String str) => UserInfoModel.fromJson(json.decode(str));
//
// String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());
//
// class UserInfoModel {
//   UserInfoModel({
//     this.token,
//     this.user,
//   });
//
//   String token;
//   User user;
//
//   factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
//     token: json["token"],
//     user: User.fromJson(json["user"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "token": token,
//     "user": user.toJson(),
//   };
// }
//
// class User {
//   User({
//     this.id,
//     this.fName,
//     this.lName,
//     this.email,
//     this.userType,
//     this.isActive,
//     this.image,
//     this.isPhoneVerified,
//     this.emailVerifiedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.emailVerificationToken,
//     this.phone,
//     this.cmFirebaseToken,
//     this.point,
//     this.temporaryToken,
//     this.loginMedium,
//   });
//
//   int id;
//   String fName;
//   String lName;
//   String email;
//   dynamic userType;
//   String isActive;
//   dynamic image;
//   int isPhoneVerified;
//   dynamic emailVerifiedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//   dynamic emailVerificationToken;
//   String phone;
//   String cmFirebaseToken;
//   int point;
//   String temporaryToken;
//   dynamic loginMedium;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"]??'',
//     fName: json["f_name"],
//     lName: json["l_name"],
//     email: json["email"],
//     userType: json["user_type"],
//     isActive: json["is_active"],
//     image: json["image"],
//     isPhoneVerified: json["is_phone_verified"],
//     emailVerifiedAt: json["email_verified_at"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     emailVerificationToken: json["email_verification_token"],
//     phone: json["phone"],
//     cmFirebaseToken: json["cm_firebase_token"],
//     point: json["point"],
//     temporaryToken: json["temporary_token"],
//     loginMedium: json["login_medium"]??'email',
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "f_name": fName,
//     "l_name": lName,
//     "email": email,
//     "user_type": userType,
//     "is_active": isActive,
//     "image": image,
//     "is_phone_verified": isPhoneVerified,
//     "email_verified_at": emailVerifiedAt,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "email_verification_token": emailVerificationToken,
//     "phone": phone,
//     "cm_firebase_token": cmFirebaseToken,
//     "point": point,
//     "temporary_token": temporaryToken,
//     "login_medium": loginMedium,
//   };
// }