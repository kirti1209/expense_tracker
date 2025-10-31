part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ToggleDarkMode extends SettingsEvent {
  const ToggleDarkMode();
}

class ChangeCurrency extends SettingsEvent {
  final String currency;

  const ChangeCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

class ExportData extends SettingsEvent {
  const ExportData();
}

class ClearAllData extends SettingsEvent {
  const ClearAllData();
}