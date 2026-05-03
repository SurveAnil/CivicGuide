/// Represents a user's profile, containing auth and voter data.
class UserProfile {
  /// The unique identifier from Firebase Auth.
  final String uid;
  /// The user's display name.
  final String? displayName;
  /// The user's email address.
  final String? email;
  /// The URL to the user's profile photo.
  final String? photoUrl;

  /// The voter's EPIC (Elector Photo Identity Card) number.
  final String? epicNumber; // Voter ID Number
  /// The voter's full name extracted via OCR.
  final String? voterName;
  /// The voter's relative (e.g., father/husband) name.
  final String? relativeName;
  /// The voter's gender.
  final String? gender;
  /// The voter's date of birth.
  final String? dateOfBirth;
  /// The state the voter is registered in.
  final String? state;
  /// Progress map for voting checklist items.
  final Map<String, bool>? checklistProgress;
  /// The user's preferred language.
  final String? languagePreference;

  /// Creates a [UserProfile] with the given properties.
  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.epicNumber,
    this.voterName,
    this.relativeName,
    this.gender,
    this.dateOfBirth,
    this.state,
    this.checklistProgress,
    this.languagePreference,
  });

  /// Converts the profile instance into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'epicNumber': epicNumber,
      'voterName': voterName,
      'relativeName': relativeName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'state': state,
      'checklistProgress': checklistProgress,
      'languagePreference': languagePreference,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates a [UserProfile] instance from a Map retrieved from Firestore.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      displayName: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      epicNumber: map['epicNumber'],
      voterName: map['voterName'],
      relativeName: map['relativeName'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      state: map['state'],
      checklistProgress: map['checklistProgress'] != null 
          ? Map<String, bool>.from(map['checklistProgress']) 
          : null,
      languagePreference: map['languagePreference'],
    );
  }
}
