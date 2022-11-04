class SessionHelper {
  static String? displayName;
  static String? firstName;
  static String? lastName;

  static String? username;
  static String? phone;
  static String? age;
  static String? uid;
  static String? profileImageUrl;
}

class SessionHelperEmpty {
  SessionHelperEmpty() {
    SessionHelper.age = null;
    SessionHelper.displayName = null;
    SessionHelper.firstName = null;
    SessionHelper.lastName = null;
    SessionHelper.username = null;
    SessionHelper.phone = null;
    SessionHelper.uid = null;
    SessionHelper.profileImageUrl = null;
  }
}
