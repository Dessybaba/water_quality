import 'package:hive/hive.dart';
import 'water_quality_record.dart';

class WaterQualityRecordAdapter extends TypeAdapter<WaterQualityRecord> {
  @override
  final int typeId = 0;

  @override
  WaterQualityRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterQualityRecord(
      id: fields[0] as String,
      locationName: fields[1] as String,
      latitude: fields[2] as double?,
      longitude: fields[3] as double?,
      address: fields[4] as String?,
      pH: fields[5] as double?,
      electricalConductivity: fields[6] as double?,
      totalDissolvedSolids: fields[7] as double?,
      biologicalOxygenDemand: fields[8] as double?,
      chemicalOxygenDemand: fields[9] as double?,
      dissolvedOxygen: fields[10] as double?,
      turbidity: fields[11] as double?,
      totalColiform: fields[12] as double?,
      fecalColiform: fields[13] as double?,
      nitrate: fields[14] as double?,
      phosphate: fields[15] as double?,
      waterQualityIndex: fields[16] as double?,
      waterQualityClass: fields[17] as String,
      createdAt: DateTime.parse(fields[18] as String),
      notes: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WaterQualityRecord obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.locationName)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.pH)
      ..writeByte(6)
      ..write(obj.electricalConductivity)
      ..writeByte(7)
      ..write(obj.totalDissolvedSolids)
      ..writeByte(8)
      ..write(obj.biologicalOxygenDemand)
      ..writeByte(9)
      ..write(obj.chemicalOxygenDemand)
      ..writeByte(10)
      ..write(obj.dissolvedOxygen)
      ..writeByte(11)
      ..write(obj.turbidity)
      ..writeByte(12)
      ..write(obj.totalColiform)
      ..writeByte(13)
      ..write(obj.fecalColiform)
      ..writeByte(14)
      ..write(obj.nitrate)
      ..writeByte(15)
      ..write(obj.phosphate)
      ..writeByte(16)
      ..write(obj.waterQualityIndex)
      ..writeByte(17)
      ..write(obj.waterQualityClass)
      ..writeByte(18)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(19)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterQualityRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
