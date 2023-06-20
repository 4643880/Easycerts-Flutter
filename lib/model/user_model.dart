import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  UserModel({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    int? approved,
    int? verified,
    String? verificationToken,
    String? createdAt,
    String? updatedAt,
    Engineer? engineer,
  }) {
    _id = id;
    _name = name;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _approved = approved;
    _verified = verified;
    _verificationToken = verificationToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _engineer = engineer;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _approved = json['approved'];
    _verified = json['verified'];
    _verificationToken = json['verification_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _engineer =
        json['engineer'] != null ? Engineer.fromJson(json['engineer']) : null;
  }
  @HiveField(0)
  int? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _firstName;
  @HiveField(3)
  String? _lastName;
  @HiveField(4)
  String? _email;
  @HiveField(5)
  int? _approved;
  @HiveField(6)
  int? _verified;
  @HiveField(7)
  String? _verificationToken;
  @HiveField(8)
  String? _createdAt;
  @HiveField(9)
  String? _updatedAt;
  @HiveField(10)
  Engineer? _engineer;
  UserModel copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    int? approved,
    int? verified,
    String? verificationToken,
    String? createdAt,
    String? updatedAt,
    Engineer? engineer,
  }) =>
      UserModel(
        id: id ?? _id,
        name: name ?? _name,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        approved: approved ?? _approved,
        verified: verified ?? _verified,
        verificationToken: verificationToken ?? _verificationToken,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        engineer: engineer ?? _engineer,
      );
  int? get id => _id;
  String? get name => _name;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  int? get approved => _approved;
  int? get verified => _verified;
  String? get verificationToken => _verificationToken;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Engineer? get engineer => _engineer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['approved'] = _approved;
    map['verified'] = _verified;
    map['verification_token'] = _verificationToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_engineer != null) {
      map['engineer'] = _engineer?.toJson();
    }
    return map;
  }
}

@HiveType(typeId: 1)
class Engineer {
  Engineer({
    int? id,
    dynamic gasSafeIdNumber,
    String? profilePhoto,
    String? mobileNumber,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? lat,
    String? long,
    String? currentLat,
    String? currentLong,
    String? locationUpdatedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _gasSafeIdNumber = gasSafeIdNumber;
    _profilePhoto = profilePhoto;
    _mobileNumber = mobileNumber;
    _address = address;
    _city = city;
    _country = country;
    _postalCode = postalCode;
    _lat = lat;
    _long = long;
    _currentLat = currentLat;
    _currentLong = currentLong;
    _locationUpdatedAt = locationUpdatedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Engineer.fromJson(dynamic json) {
    _id = json['id'];
    _gasSafeIdNumber = json['gas_safe_id_number'];
    _profilePhoto = json['profile_photo'];
    _mobileNumber = json['mobile_number'];
    _address = json['address'];
    _city = json['city'];
    _country = json['country'];
    _postalCode = json['postal_code'];
    _lat = json['lat'];
    _long = json['long'];
    _currentLat = json['current_lat'];
    _currentLong = json['current_long'];
    _locationUpdatedAt = json['location_updated_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  @HiveField(0)
  int? _id;
  @HiveField(1)
  dynamic _gasSafeIdNumber;
  @HiveField(2)
  String? _profilePhoto;
  @HiveField(3)
  String? _mobileNumber;
  @HiveField(4)
  String? _address;
  @HiveField(5)
  String? _city;
  @HiveField(6)
  String? _country;
  @HiveField(7)
  String? _postalCode;
  @HiveField(8)
  String? _lat;
  @HiveField(9)
  String? _long;
  @HiveField(10)
  String? _currentLat;
  @HiveField(11)
  String? _currentLong;
  @HiveField(12)
  String? _locationUpdatedAt;
  @HiveField(13)
  String? _createdAt;
  @HiveField(14)
  String? _updatedAt;
  Engineer copyWith({
    int? id,
    dynamic gasSafeIdNumber,
    String? profilePhoto,
    String? mobileNumber,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? lat,
    String? long,
    String? currentLat,
    String? currentLong,
    String? locationUpdatedAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      Engineer(
        id: id ?? _id,
        gasSafeIdNumber: gasSafeIdNumber ?? _gasSafeIdNumber,
        profilePhoto: profilePhoto ?? _profilePhoto,
        mobileNumber: mobileNumber ?? _mobileNumber,
        address: address ?? _address,
        city: city ?? _city,
        country: country ?? _country,
        postalCode: postalCode ?? _postalCode,
        lat: lat ?? _lat,
        long: long ?? _long,
        currentLat: currentLat ?? _currentLat,
        currentLong: currentLong ?? _currentLong,
        locationUpdatedAt: locationUpdatedAt ?? _locationUpdatedAt,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  int? get id => _id;
  dynamic get gasSafeIdNumber => _gasSafeIdNumber;
  String? get profilePhoto => _profilePhoto;
  String? get mobileNumber => _mobileNumber;
  String? get address => _address;
  String? get city => _city;
  String? get country => _country;
  String? get postalCode => _postalCode;
  String? get lat => _lat;
  String? get long => _long;
  String? get currentLat => _currentLat;
  String? get currentLong => _currentLong;
  String? get locationUpdatedAt => _locationUpdatedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['gas_safe_id_number'] = _gasSafeIdNumber;
    map['profile_photo'] = _profilePhoto;
    map['mobile_number'] = _mobileNumber;
    map['address'] = _address;
    map['city'] = _city;
    map['country'] = _country;
    map['postal_code'] = _postalCode;
    map['lat'] = _lat;
    map['long'] = _long;
    map['current_lat'] = _currentLat;
    map['current_long'] = _currentLong;
    map['location_updated_at'] = _locationUpdatedAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
