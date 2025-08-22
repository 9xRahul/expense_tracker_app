part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavigationSetIndex extends NavigationEvent {
  final int index;
  NavigationSetIndex(this.index);
  @override
  List<Object?> get props => [index];
}
