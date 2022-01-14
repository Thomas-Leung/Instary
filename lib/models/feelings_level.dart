class FeelingsLevel {
  double happinessLv;
  double tirednessLv;
  double stressfulnessLv;

  FeelingsLevel(this.happinessLv, this.tirednessLv, this.stressfulnessLv);

  // In dart, we cannot overload constructor, but we can create a named constructor
  // I just named it init, we can name whatever we want
  FeelingsLevel.init()
      : happinessLv = 50,
        tirednessLv = 50,
        stressfulnessLv = 50;
}
