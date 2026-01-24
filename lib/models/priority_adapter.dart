import 'package:hive/hive.dart';
import 'priority.dart';

class PriorityLevelAdapter extends TypeAdapter<PriorityLevel> {
  @override
  final int typeId = 2;

  @override
  PriorityLevel read(BinaryReader reader) {
    final index = reader.readInt();
    return PriorityLevel.values[index];
  }

  @override
  void write(BinaryWriter writer, PriorityLevel obj) {
    writer.writeInt(obj.index);
  }
}
