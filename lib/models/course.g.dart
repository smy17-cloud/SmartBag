// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'course.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
//
// Ce fichier est normalement généré automatiquement par la commande :
//   flutter pub run build_runner build --delete-conflicting-outputs
//
// Il est fourni ici "pré-généré" pour que le projet compile immédiatement.
// Si tu modifies les champs de Course (ajout/suppression de @HiveField),
// il faudra relancer build_runner pour régénérer ce fichier.

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 0;

  @override
  Course read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Course(
      id: fields[0] as String,
      name: fields[1] as String,
      qrCode: fields[2] as String,
      dayOfWeek: fields[3] as int,
      isChecked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.qrCode)
      ..writeByte(3)
      ..write(obj.dayOfWeek)
      ..writeByte(4)
      ..write(obj.isChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
