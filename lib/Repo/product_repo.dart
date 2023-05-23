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
  List<String>? timestamp;
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
    timestamp = json['timestamp'].cast<String>();
    locationURL = json['locationURL'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageURL'] = this.imageURL;
    data['locationStatuses'] = this.locationStatuses;
    data['timestamp'] = this.timestamp;
    data['locationURL'] = this.locationURL;
    return data;
  }
}
