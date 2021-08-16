@JS()
library callable_function;

import 'package:js/js.dart';

@JS('triggerNoteEvent')
external set triggerNoteEvent(void Function(dynamic) f);
