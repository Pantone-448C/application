import 'package:equatable/equatable.dart';

abstract class EditState extends Equatable {}

class Editing implements EditState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class Saving implements EditState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class Saved implements EditState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}