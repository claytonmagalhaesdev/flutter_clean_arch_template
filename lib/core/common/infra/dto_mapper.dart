import 'package:flutter_clean_arch_template/core/common/types/types.dart';

abstract interface class DtoMapper<Dto> {
  Dto toDto(Json json);
}

abstract interface class JsonMapper<Dto> {
  Json toJson(Dto dto);
}

abstract interface class Mapper<Dto>
    implements DtoMapper<Dto>, JsonMapper<Dto> {}

mixin DtoListMapper<Dto> implements DtoMapper<Dto> {
  List<Dto> toDtoList(dynamic arr) => (arr as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .map<Dto>((json) => toDto(json))
      .toList();
}

mixin JsonArrMapper<Dto> implements JsonMapper<Dto> {
  JsonArr toJsonArr(List<Dto> list) => list.map(toJson).toList();
}

abstract base class ListMapper<Dto>
    with DtoListMapper<Dto>, JsonArrMapper<Dto> {}
