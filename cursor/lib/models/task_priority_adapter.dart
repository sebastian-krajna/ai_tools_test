import 'package:hive/hive.dart';
import 'task.dart';

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    return TaskPriority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    writer.writeInt(obj.index);
  }
} 