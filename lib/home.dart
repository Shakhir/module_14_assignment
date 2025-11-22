import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:module_14_assignment/product_controller.dart';

class ApiCalll extends StatefulWidget {
  const ApiCalll({super.key});

  @override
  State<ApiCalll> createState() => _ApiCalllState();
}

class _ApiCalllState extends State<ApiCalll> {
  ProductController productController = ProductController();
  List products =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }
  Future<void>fetchProduct()async {
    await productController.fetchProduct();
    if (mounted){
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api"),
      ),
      body: productController.isLoading?Center(child: CircularProgressIndicator()) : GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 1,childAspectRatio: 0.7),
          itemCount: productController.products.length,

          itemBuilder: (context, index) {
            final item = productController.products[index];
            return Card(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Image.network(
                        item.img.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      item.productName.toString(),
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("Price ${item.unitPrice} | Qty ${item.qty}"),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.deepOrange,)),
                        IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.redAccent,)),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
