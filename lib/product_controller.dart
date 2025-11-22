
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:module_14_assignment/model/product_model.dart';
import 'package:module_14_assignment/utils/urls.dart';

class ProductController {
  List<Data>products = [];
  bool isLoading = true;
  Future fetchProduct() async {
    final response = await http.get(Uri.parse(Urls.ReadProduct));
    if (response.statusCode == 200) {
      isLoading = false;
      final jsonResponse = jsonDecode(response.body);
      final data = jsonDecode(response.body);
      ProductModel model = ProductModel.fromJson(data);
      products = model.data ?? [];
    }
  }
}