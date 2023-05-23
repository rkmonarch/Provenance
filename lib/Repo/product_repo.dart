import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trust_chain/resources/ui_helpers.dart';

class ProductRepo {
  Future<ProductModel> getProduct({required String productID}) async {
    final responce = await http.get(
      Uri.parse("https://provenance-new.vercel.app/api/get-details/?id=${productID}"),
    );
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      lg.wtf("Success");
      lg.d(responce.body);
      return ProductModel.fromJson(jsonDecode(responce.body));
    } else {
      lg.d(responce.body);
    }
    throw UnimplementedError();
  }
}

class ProductModel {
  String? name;
  String? description;
  String? imageURL;
  List<String>? locationStatuses;
  List<Timestamp>? timestamp;
  List<String>? locationURL;

  ProductModel(
      {this.name,
      this.description,
      this.imageURL,
      this.locationStatuses,
      this.timestamp,
      this.locationURL});

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    imageURL = json['imageURL'];
    locationStatuses = json['locationStatuses'].cast<String>();
    if (json['timestamp'] != null) {
      timestamp = <Timestamp>[];
      json['timestamp'].forEach((v) {
        timestamp!.add(new Timestamp.fromJson(v));
      });
    }
    locationURL = json['locationURL'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageURL'] = this.imageURL;
    data['locationStatuses'] = this.locationStatuses;
    if (this.timestamp != null) {
      data['timestamp'] = this.timestamp!.map((v) => v.toJson()).toList();
    }
    data['locationURL'] = this.locationURL;
    return data;
  }
}

class Timestamp {
  String? type;
  String? hex;

  Timestamp({this.type, this.hex});

  Timestamp.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    hex = json['hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['hex'] = this.hex;
    return data;
  }
}
