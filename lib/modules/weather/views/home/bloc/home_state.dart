part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.weather,
  });

  final HomeStatus status;
  final Weather? weather;

  HomeState copyWith({
    HomeStatus? status,
    Weather? weather,
  }) {
    return HomeState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
    );
  }

  @override
  List<Object?> get props => [status, weather];
}
