// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictionAdapter extends TypeAdapter<Prediction> {
  @override
  final int typeId = 0;

  @override
  Prediction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prediction(
      plantName: fields[0] as String,
      confidence: fields[1] as double,
      image: fields[2] as String,
      date: fields[3] == null ? '' : fields[3] as String,
      description: fields[4] == null ? '' : fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prediction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.plantName)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
