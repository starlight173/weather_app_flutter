import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/modules/app_setting/bloc/app_setting_bloc.dart';
import 'package:flutter_weather_app/providers/repositories/shared_preferences_repository.dart';
import 'package:settings_ui/settings_ui.dart';

import '../bloc/settings_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) =>
          SettingsBloc(context.read<ISharedPreferencesRepository>())
            ..add(SettingsLoaded())),
      child: const _SettingsScreen(),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          context
              .read<AppSettingBloc>()
              .add(AppSettingTemperatureChanged(state.temperatureStatus));
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  tiles: [
                    SettingsTile(
                      onPressed: (context) => {
                        print('Language'),
                      },
                      title: const Text('Language'),
                      leading: const Icon(Icons.language),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'English',
                          items: const [
                            DropdownMenuItem(
                              child: Text('English'),
                              value: 'English',
                            ),
                            DropdownMenuItem(
                              child: Text('Vietnamese'),
                              value: 'Vietnamese',
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    SettingsTile(
                      title: const Text('Temperature'),
                      leading: const Icon(Icons.thermostat),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.temperatureStatus.name,
                          items: const [
                            DropdownMenuItem(
                              value: 'Celcius',
                              child: Text('Celcius'),
                            ),
                            DropdownMenuItem(
                              value: 'Fahrenheit',
                              child: Text('Fahrenheit'),
                            ),
                          ],
                          onChanged: (value) {
                            context
                                .read<SettingsBloc>()
                                .add(SettingsTemperatureChanged(value!));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
