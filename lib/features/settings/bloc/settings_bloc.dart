import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/settings_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/export_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ChangeCurrency>(_onChangeCurrency);
    on<ExportData>(_onExportData);
    on<ClearAllData>(_onClearAllData);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    
    try {
      final settings = await StorageService.getSettings();
      emit(state.copyWith(settings: settings, status: SettingsStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.failure,
        error: 'Failed to load settings: $e',
      ));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final newSettings = state.settings.copyWith(isDarkMode: !state.settings.isDarkMode);
      await StorageService.saveSettings(newSettings);
      emit(state.copyWith(settings: newSettings));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update theme: $e'));
    }
  }

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final newSettings = state.settings.copyWith(currency: event.currency);
      await StorageService.saveSettings(newSettings);
      emit(state.copyWith(settings: newSettings));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to update currency: $e'));
    }
  }

  Future<void> _onExportData(
    ExportData event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await ExportService.exportToCSV();
      emit(state.copyWith(message: 'Data exported successfully'));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to export data: $e'));
    }
  }

  Future<void> _onClearAllData(
    ClearAllData event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await StorageService.clearAllData();
      final settings = await StorageService.getSettings();
      emit(state.copyWith(
        settings: settings,
        message: 'All data cleared successfully',
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to clear data: $e'));
    }
  }
}