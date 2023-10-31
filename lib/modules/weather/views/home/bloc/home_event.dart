part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeEvent {
  const HomeLoaded();
}

class HomeBgToFg extends HomeEvent {
  const HomeBgToFg();
}
