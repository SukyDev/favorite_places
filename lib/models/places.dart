import 'package:equatable/equatable.dart';
import 'package:favorite_places/models/place.dart';

class Places extends Equatable {
  List<Place> placesArray;

  Places(this.placesArray);

  @override
  List<Object?> get props => [placesArray];

  static fromJson(Map<String, dynamic> json) {
    return Places(json['placesArray'],);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['placesArray'] = placesArray;
    return data;
  }
}