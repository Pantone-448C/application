import 'package:equatable/equatable.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial implements ProfileState {
  const ProfileInitial();
}

class ProfileLoaded extends Equatable implements ProfileState {
  const ProfileLoaded(this.firstName, this.lastName, this.points, this.imgUrl);

  final String firstName;
  final String lastName;
  final int points;
  final String imgUrl;

  @override
  List<Object?> get props => [firstName, lastName, points, imgUrl];

  ProfileState copyWith({
    String? firstName,
    String? lastName,
    int? points,
    String? imgUrl,
  }) {
    return ProfileLoaded(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      points ?? this.points,
      imgUrl ?? this.imgUrl,
    );
  }
}
