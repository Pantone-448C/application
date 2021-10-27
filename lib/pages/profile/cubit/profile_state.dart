import 'package:application/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial implements ProfileState {
  const ProfileInitial();
}

class ProfileLoaded extends Equatable implements ProfileState {
  const ProfileLoaded(this.firstName, this.lastName, this.points, this.imgUrl, this.user);

  final UserDetails user;
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
    UserDetails? user,
  }) {
    return ProfileLoaded(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      points ?? this.points,
      imgUrl ?? this.imgUrl,
      user?? this.user,
    );
  }
}
