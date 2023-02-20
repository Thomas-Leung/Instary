import 'package:flutter/material.dart';
import 'package:instary/models/feelings_level.dart';

class FeelingsCard extends StatefulWidget {
  final FeelingsLevel existingLevel;
  final Function(FeelingsLevel) onLevelChanged;

  const FeelingsCard(
      {Key? key, required this.existingLevel, required this.onLevelChanged})
      : super(key: key);

  @override
  _FeelingsCardState createState() => _FeelingsCardState();
}

class _FeelingsCardState extends State<FeelingsCard> {
  FeelingsLevel level = FeelingsLevel.init();

  @override
  void initState() {
    super.initState();
    level = widget.existingLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Rate your feelings',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            ),
            Container(
              child: Text("Happiness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_dissatisfied),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor:
                            Theme.of(context).sliderTheme.activeTrackColor,
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Theme.of(context).sliderTheme.thumbColor,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: level.happinessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            level.happinessLv = value.roundToDouble();
                          });
                          widget.onLevelChanged(level);
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.sentiment_satisfied)
                ],
              ),
            ),
            Container(
              child: Text("Tiredness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.battery_charging_full),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor:
                            Theme.of(context).sliderTheme.activeTrackColor,
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Theme.of(context).sliderTheme.thumbColor,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: level.tirednessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            level.tirednessLv = value.roundToDouble();
                          });
                          widget.onLevelChanged(level);
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.airline_seat_flat)
                ],
              ),
            ),
            Container(
              child: Text("Stressfulness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_very_satisfied),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor:
                            Theme.of(context).sliderTheme.activeTrackColor,
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Theme.of(context).sliderTheme.thumbColor,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: level.stressfulnessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            level.stressfulnessLv = value.roundToDouble();
                          });
                          widget.onLevelChanged(level);
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.sentiment_very_dissatisfied)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
