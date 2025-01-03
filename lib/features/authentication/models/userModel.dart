import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lhstore/utils/formatters/formatters.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String userName;
  final String email;
  String phoneNumber; 
  String profilePicture;
  String address;
  bool isAdmin; // New field

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.address,
    this.isAdmin = false, // Default value is false
  });

  String get fullName => '$firstName $lastName';
  String get formattedPhoneNo => LHFormatters.formatPhoneNumber(phoneNumber);

  static List<String> nameParts(fullName) => fullName.split(" ");

  static String generateUserName(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        userName: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        address: '',
        isAdmin: false, // Default value for empty user
      );

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Address': address,
      '_isAdmin': isAdmin, // Include _isAdmin in JSON
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        userName: data['UserName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        address: data['Address'] ?? '',
        isAdmin: data['_isAdmin'] ?? false, // Default false if not present
      );
    } else {
      return UserModel.empty();
    }
  }
}
