import 'package:flutter/material.dart';
import 'package:emily_marathon_split_calculator/ui/theme/theme.dart';

/// Base input decoration that all inputs should use for consistency
InputDecoration _baseInputDecoration(
  BuildContext context, {
  String? hintText,
  String? labelText,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Theme.of(context).colorScheme.surfaceContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: appTheme(context).cardPadding,
      vertical: appTheme(context).cardPadding,
    ),
  );
}

/// Consistent label widget for all inputs
class InputLabel extends StatelessWidget {
  final String text;
  final bool required;

  const InputLabel({
    super.key,
    required this.text,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

/// Consistent spacing between input elements
class InputSpacing extends StatelessWidget {
  final double? height;

  const InputSpacing({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? appTheme(context).cardSpacing / 2);
  }
}

/// Standard dropdown input widget
class StandardDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const StandardDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: _baseInputDecoration(
        context,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Standard text input widget
class StandardTextInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;

  const StandardTextInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      decoration: _baseInputDecoration(
        context,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Interactive time input widget with plus/minus controls
class InteractiveTimeInput extends StatefulWidget {
  final Duration initialTime;
  final ValueChanged<Duration> onTimeChanged;
  final String label;
  final bool showLabel;
  final bool showSeconds;

  const InteractiveTimeInput({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.label = "Time",
    this.showLabel = true,
    this.showSeconds = true,
  });

  @override
  State<InteractiveTimeInput> createState() => _InteractiveTimeInputState();
}

class _InteractiveTimeInputState extends State<InteractiveTimeInput> {
  late int hours;
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    hours = widget.initialTime.inHours;
    minutes = widget.initialTime.inMinutes % 60;
    seconds = widget.initialTime.inSeconds % 60;
  }

  void _updateTime() {
    final newTime = Duration(
      hours: hours,
      minutes: minutes,
      seconds: widget.showSeconds ? seconds : 0,
    );
    widget.onTimeChanged(newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          InputLabel(text: widget.label),
          const InputSpacing(),
        ],
        Container(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              if (!widget.showSeconds || hours > 0) ...[
                _TimeInputField(
                  label: 'Hours',
                  value: hours,
                  min: 0,
                  max: 23,
                  onChanged: (value) {
                    setState(() {
                      hours = value;
                      _updateTime();
                    });
                  },
                ),
                const SizedBox(width: 16),
                const Text(
                  ':',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
              ],
              _TimeInputField(
                label: 'Minutes',
                value: minutes,
                min: 0,
                max: 59,
                onChanged: (value) {
                  setState(() {
                    minutes = value;
                    _updateTime();
                  });
                },
              ),
              if (widget.showSeconds) ...[
                const SizedBox(width: 16),
                const Text(
                  ':',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                _TimeInputField(
                  label: 'Seconds',
                  value: seconds,
                  min: 0,
                  max: 59,
                  onChanged: (value) {
                    setState(() {
                      seconds = value;
                      _updateTime();
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeInputField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _TimeInputField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Units toggle widget
class UnitsToggle extends StatelessWidget {
  final bool useMetricUnits;
  final ValueChanged<bool> onChanged;
  final String label;
  final bool showLabel;

  const UnitsToggle({
    super.key,
    required this.useMetricUnits,
    required this.onChanged,
    this.label = "Units",
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          InputLabel(text: label),
          const InputSpacing(),
        ],
        Container(
          padding: EdgeInsets.all(appTheme(context).cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(appTheme(context).borderRadius),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.straighten_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Use metric units (km)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Switch(
                value: useMetricUnits,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Standard button widget
class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;

  const StandardButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: appTheme(context).cardPadding,
              vertical: appTheme(context).cardPadding,
            ),
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: appTheme(context).cardPadding,
                  vertical: appTheme(context).cardPadding,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
              label: Text(text),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: appTheme(context).cardPadding,
                  vertical: appTheme(context).cardPadding,
                ),
              ),
            ),
    );
  }
}
