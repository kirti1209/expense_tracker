part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsModel settings;
  final SettingsStatus status;
  final String? error;
  final String? message;

  const SettingsState({
    this.settings = const SettingsModel(),
    this.status = SettingsStatus.initial,
    this.error,
    this.message,
  });

  SettingsState copyWith({
    SettingsModel? settings,
    SettingsStatus? status,
    String? error,
    String? message,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [settings, status, error, message];
}