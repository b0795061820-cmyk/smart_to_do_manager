enum PriorityLevel { low, medium, high }

extension PriorityLevelX on PriorityLevel {
  String get label {
    switch (this) {
      case PriorityLevel.low:
        return "Low";
      case PriorityLevel.medium:
        return "Medium";
      case PriorityLevel.high:
        return "High";
    }
  }

  int get weight {
    switch (this) {
      case PriorityLevel.low:
        return 1;
      case PriorityLevel.medium:
        return 2;
      case PriorityLevel.high:
        return 3;
    }
  }
}
