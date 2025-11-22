import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:module_14_assignment/model/product_model.dart';
import 'package:module_14_assignment/utils/urls.dart';

class ProductController {
  List<Data> products = [];
  bool isLoading = true;

  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse(Urls.readProduct));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      ProductModel model = ProductModel.fromJson(jsonResponse);

      products = model.data ?? [];
    }

    isLoading = false;
  }
  Future<bool> createProduct(Data data) async {
    final response = await http.post(
      Uri.parse(Urls.createProduct),
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        "ProductName": data.productName,
        "ProductCode": DateTime.now().microsecondsSinceEpoch,
        "Img": data.img,
        "Qty": data.qty,
        "UnitPrice": data.unitPrice,
        "TotalPrice": data.totalPrice,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProduct(Data item) async {
    final url = Uri.parse("${Urls.baseURL}/UpdateProduct/${item.sId}");

    final body = jsonEncode({
      "ProductName": item.productName,
      "ProductCode": item.productCode,   // ← REQUIRED
      "Img": item.img,
      "Qty": item.qty,
      "UnitPrice": item.unitPrice,
      "TotalPrice": item.totalPrice
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    print("UPDATE STATUS → ${response.statusCode}");
    print("UPDATE BODY → ${response.body}");

    return response.statusCode == 200;
  }


}
