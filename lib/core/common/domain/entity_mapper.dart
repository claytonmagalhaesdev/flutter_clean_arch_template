abstract interface class EntityToDtoMapper<Dto, Entity> {
  Dto toDto(Entity entity);
}

abstract interface class DtoToEntityMapper<Dto, Entity> {
  Entity toEntity(Dto dto);
}

abstract interface class EntityMapper<Dto, Entity>
    implements DtoToEntityMapper<Dto, Entity>, EntityToDtoMapper<Dto, Entity> {}

mixin DtoToEntityListMapper<Dto, Entity>
    implements DtoToEntityMapper<Dto, Entity> {
  List<Entity> toEntityList(List<Dto> list) =>
      list.map<Entity>(toEntity).toList();
}

mixin EntityToDtoListMapper<Dto, Entity>
    implements EntityToDtoMapper<Dto, Entity> {
  List<Dto> toDtoList(List<Entity> list) => list.map<Dto>(toDto).toList();
}

abstract base class EntityListMapper<Dto, Entity>
    with DtoToEntityListMapper<Dto, Entity>, EntityToDtoListMapper<Dto, Entity>
    implements EntityMapper<Dto, Entity> {}
