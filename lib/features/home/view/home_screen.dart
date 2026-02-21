import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:breatheasy/config/theme_config/viewmodel/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/home/view_model/home_view_model.dart';
import 'package:breatheasy/core/utils/responsive_layout.dart';
import 'package:breatheasy/features/home/view/components/home_app_bar.dart';
import 'package:breatheasy/features/home/view/components/option_selector.dart';
import 'package:breatheasy/features/home/view/components/sound_settings_section.dart';
import 'package:breatheasy/features/home/view/components/start_breathing_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _advancedTimingExpanded = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(homeViewModelProvider);
    ref.watch(themeViewModelProvider);
    final preferences = ref.watch(homePreferencesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).initHome();
      ref.read(themeViewModelProvider.notifier).initTheme();
    });

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.colors.topgradient, context.colors.bottomgradient],
        ),
      ),
      child: Scaffold(
        appBar: const HomeAppBar(),
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ResponsiveContainer(
                maxWidth: 800,
                horizontalPadding: constraints.maxWidth > 900 ? 48.0 : 27.0,
                verticalPadding: constraints.maxWidth > 900 ? 48.0 : 27.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HomePageHeader(isWeb: constraints.maxWidth > 900),
                    SizedBox(height: constraints.maxWidth > 900 ? 48 : 32),

                    _buildLayout(
                      context,
                      preferences,
                      constraints.maxWidth > 900,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, dynamic preferences, bool isWeb) {
    return Column(
      children: [
        Container(
          width: isWeb ? 600 : double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 21, vertical: 32),
          decoration: BoxDecoration(
            color: context.colors.glassy,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OptionSelector(
                title: 'Breath duration',
                subtitle: 'Seconds per phase',
                options: const [3, 4, 5, 10],
                selectedValue: preferences.breathDuration,
                onSelect: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateBreathDuration(value);
                },
                type: OptionType.breath,
              ),
              const SizedBox(height: 24),
              OptionSelector(
                title: 'Rounds',
                subtitle: 'Full box breathing cycles',
                options: const [2, 4, 6, 8],
                selectedValue: preferences.rounds,
                onSelect: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateRounds(value);
                },
                type: OptionType.rounds,
              ),
              const SizedBox(height: 24),
              _buildExpandableAdvancedTiming(context, preferences),
              const SizedBox(height: 24),
              SoundSettingsSection(
                soundEnabled: preferences.soundEnabled,
                onChanged: (value) {
                  ref.read(homePreferencesProvider.notifier).toggleSound();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        StartBreathingButton(preferences: preferences),
      ],
    );
  }

  Widget _buildExpandableAdvancedTiming(
    BuildContext context,
    dynamic preferences,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _advancedTimingExpanded = !_advancedTimingExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced timing',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set different durations for each phase',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Icon(
                _advancedTimingExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
        if (_advancedTimingExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimingControl(
                  label: 'Breathe in',
                  value: preferences.breatheIn,
                  onChanged: (value) {
                    ref
                        .read(homePreferencesProvider.notifier)
                        .updateBreatheIn(value);
                  },
                ),
                const SizedBox(height: 12),
                _TimingControl(
                  label: 'Hold in',
                  value: preferences.holdIn,
                  onChanged: (value) {
                    ref
                        .read(homePreferencesProvider.notifier)
                        .updateHoldIn(value);
                  },
                ),
                const SizedBox(height: 12),
                _TimingControl(
                  label: 'Breathe out',
                  value: preferences.breatheOut,
                  onChanged: (value) {
                    ref
                        .read(homePreferencesProvider.notifier)
                        .updateBreatheOut(value);
                  },
                ),
                const SizedBox(height: 12),
                _TimingControl(
                  label: 'Hold out',
                  value: preferences.holdOut,
                  onChanged: (value) {
                    ref
                        .read(homePreferencesProvider.notifier)
                        .updateHoldOut(value);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TimingControl extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const _TimingControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.bgPage,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: context.colors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: [
              ClipOval(
                child: InkWell(
                  onTap: value > 1 ? () => onChanged(value - 1) : null,

                  child: Container(
                    height: 26,
                    width: 26,
                    color: context.colors.chipNeutralBg,
                    child: const Icon(Icons.remove, size: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${value}s',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ClipOval(
                child: InkWell(
                  onTap: () => onChanged(value + 1),

                  child: Container(
                    height: 26,
                    width: 26,
                    color: context.colors.chipNeutralBg,
                    child: const Icon(Icons.add, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomePageHeader extends StatelessWidget {
  final bool isWeb;

  const _HomePageHeader({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isWeb
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Set your breathing pace',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: isWeb ? 48 : 28,
            fontWeight: FontWeight.bold,
            color: context.colors.brandPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Customise your breathing session. You can always change this later.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isWeb ? 16 : 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
