import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/local_storage.dart';
import 'models/task_model.dart';

final todosProvider = StateNotifierProvider<HiveLocalStorage, List<Task>>((ref) {
  return HiveLocalStorage();
});