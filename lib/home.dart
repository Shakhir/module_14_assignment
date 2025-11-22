import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:module_14_assignment/product_controller.dart';
import 'package:module_14_assignment/utils/urls.dart';

import 'model/product_model.dart';

class ApiCalll extends StatefulWidget {
  const ApiCalll({super.key});

  @override
  State<ApiCalll> createState() => _ApiCalllState();
}

class _ApiCalllState extends State<ApiCalll> {
  final ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    await productController.fetchProduct();
    if (mounted) setState(() {});
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));
    return response.statusCode == 200;
  }



  productDialog(){
    TextEditingController productNameController = TextEditingController();
    TextEditingController productIMGController = TextEditingController();
    TextEditingController productQTYController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Add product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                  labelText: 'Name'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productIMGController,
              decoration: InputDecoration(
                  labelText: 'Image'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productQTYController,
              decoration: InputDecoration(
                  labelText: 'QTY'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productUnitPriceController,
              decoration: InputDecoration(
                  labelText: 'Unit price'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(
                  labelText: 'Total price'
              ),
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancle')),

                ElevatedButton(onPressed: () async {
                  productController.createProduct(Data(
                      productName: productNameController.text,
                      img: productIMGController.text,
                      qty: int.parse(productQTYController.text),
                      unitPrice: int.parse(productUnitPriceController.text),
                      totalPrice: int.parse(productTotalPriceController.text)
                  ));
                  await fetchProduct();
                  Navigator.pop(context);
                }, child: Text('Save',style: TextStyle(color: Colors.white),))
              ],
            )

          ],
        ),
      ),
    ));
  }
  void editProductDialog(Data item) {
    final nameController = TextEditingController(text: item.productName);
    final imgController = TextEditingController(text: item.img);
    final qtyController = TextEditingController(text: item.qty.toString());
    final unitPriceController = TextEditingController(text: item.unitPrice.toString());
    final totalPriceController = TextEditingController(text: item.totalPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: imgController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
                TextField(
                  controller: qtyController,
                  decoration: const InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: unitPriceController,
                  decoration: const InputDecoration(labelText: "Unit Price"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalPriceController,
                  decoration: const InputDecoration(labelText: "Total Price"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the item
                item.productName = nameController.text.trim();
                item.img = imgController.text.trim();
                item.qty = int.parse(qtyController.text);
                item.unitPrice = int.parse(unitPriceController.text);
                item.totalPrice = int.parse(totalPriceController.text);

                final ok = await productController.updateProduct(item);
                if (ok) {
                  Navigator.pop(context);
                  await fetchProduct();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product Updated Successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Update Failed")),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Demo")),

      body: productController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          final item = productController.products[index];
          return Card(
            elevation: 3,
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  child: Image.network(
                    item.img.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    item.productName.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("Price: ${item.unitPrice} | Qty: ${item.qty}"),

                const SizedBox(height: 6),

                /// Edit + Delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => editProductDialog(item),
                      icon: const Icon(Icons.edit, color: Colors.orange),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ok = await deleteProduct(item.sId.toString());
                        if (ok) {
                          await fetchProduct();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Product Deleted")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text("Something went wrong...!")),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: productDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
