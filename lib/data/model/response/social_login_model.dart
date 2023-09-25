class SocialLoginModel {
  String token;
  String uniqueId;
  String medium;
  String email;
  String restaurantId;
  String firstName;
  String lastName;

  SocialLoginModel({this.token, this.uniqueId, this.medium, this.email,this.restaurantId,this.firstName,this.lastName});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    uniqueId = json['unique_id'];
    medium = json['medium'];
    email = json['email'];
    firstName=json['first_name'];
    firstName=json['last_name'];
    firstName=json['restaurant_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['unique_id'] = this.uniqueId;
    data['medium'] = this.medium;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}
