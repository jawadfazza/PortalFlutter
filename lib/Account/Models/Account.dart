class Account {
  String partitionKey;
  String rowKey;
  int seq;
  String fullName;
  String email;
  String phoneNumber;
  bool accountConfirmed;
  String password;
  DateTime passwordExpiredDate;
  String gender;
  String preferdLanguage;
  String accountType;
  String profilePictureUrl;
  DateTime accountCreatedDate;
  DateTime? lastLoginDate;
  String accountStatus;
  String userRole;

  Account({
    required this.partitionKey,
    required this.rowKey,
    required this.seq,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.accountConfirmed,
    required this.password,
    required this.passwordExpiredDate,
    required this.gender,
    required this.preferdLanguage,
    required this.accountType,
    required this.profilePictureUrl,
    required this.accountCreatedDate,
    this.lastLoginDate,
    required this.accountStatus,
    required this.userRole,
  });

  // Convert Account object to JSON
  Map<String, dynamic> toJson() {
    return {
      'partitionKey': partitionKey,
      'rowKey': rowKey,
      'seq': seq,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountConfirmed': accountConfirmed,
      'password': password,
      'passwordExpiredDate': passwordExpiredDate.toIso8601String(),
      'gender': gender,
      'preferdLanguage': preferdLanguage,
      'accountType': accountType,
      'profilePictureUrl': profilePictureUrl,
      'accountCreatedDate': accountCreatedDate.toIso8601String(),
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'accountStatus': accountStatus,
      'userRole': userRole,
    };
  }

  // Create Account object from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      partitionKey: json['partitionKey'] ?? '',
      rowKey: json['rowKey'] ?? '',
      seq: json['seq'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      accountConfirmed: json['accountConfirmed'] ?? false,
      password: json['password'] ?? '',
      passwordExpiredDate: DateTime.parse(json['passwordExpiredDate'] ?? ''),
      preferdLanguage: json['preferdLanguage'] ?? '',
      gender: json['gender'] ?? '',

      accountType: json['accountType'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      accountCreatedDate: DateTime.parse(json['accountCreatedDate'] ?? ''),
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'])
          : null,
      accountStatus: json['accountStatus'] ?? '',
      userRole: json['userRole'] ?? '',
    );
  }
}
