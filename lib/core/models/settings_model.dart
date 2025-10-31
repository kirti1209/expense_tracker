import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final bool isDarkMode;
  final String currency;

  const SettingsModel({
    this.isDarkMode = false,
    this.currency = '\$',
  });

  SettingsModel copyWith({
    bool? isDarkMode,
    String? currency,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, currency];

  Map<String, dynamic> toJson() {
    return {
      'is_dark_mode': isDarkMode ? 1 : 0,
      'currency': currency,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['is_dark_mode'] == 1,
      currency: json['currency'] ?? '\$',
    );
  }
}