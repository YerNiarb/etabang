class User {
  String firstName;
  String lastName;
  String street;
  String city;
  String state;
  String profileImageUrl;
  String userName;

  User(
    {
      required this.firstName,
      required this.lastName,
      required this.street,
      required this.city, 
      required this.state,
      required this.userName,
      this.profileImageUrl = "assets/images/default-profile.png"
    }
  );
}
