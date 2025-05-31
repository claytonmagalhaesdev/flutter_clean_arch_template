import 'dart:math';

import 'package:flutter_clean_arch_template/core/common/types/types.dart';
import 'package:flutter_clean_arch_template/features/user/domain/user_entity.dart';

int anyInt([int max = 999999999]) => Random().nextInt(max);
String anyString() => anyInt().toString();
bool anyBool() => Random().nextBool();
DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(anyInt());
String anyIsoDate() => anyDate().toIso8601String();
Json anyJson() => {anyString(): anyString()};
List<Json> anyJsonArr() => List.generate(anyInt(5), (index) => anyJson());
UserEntity anyPetEntity() =>
    UserEntity(id: anyInt(), name: anyString(), email: anyString());
