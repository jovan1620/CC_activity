import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ======================================================
// APP
// ======================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bohol Tours',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ProductPage(),
    );
  }
}

// ======================================================
// PRODUCT PAGE
// ======================================================

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List products = [];
  bool isLoading = true;
  String errorMessage = '';

  // ======================================================
  // FETCH PRODUCTS FROM API
  // ======================================================

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          products = [
            {
              'title': 'Chocolate Hills Tour',
              'description':
                  'Explore the famous Chocolate Hills in Carmen, Bohol.',
              'price': 1500,
              'thumbnail':
                  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
              'category': 'Nature Tour',
            },
            {
              'title': 'Loboc River Cruise',
              'description':
                  'Enjoy a relaxing river cruise with beautiful scenery.',
              'price': 1200,
              'thumbnail':
                  'https://images.unsplash.com/photo-1544551763-46a013bb70d5',
              'category': 'River Cruise',
            },
            {
              'title': 'Tarsier Sanctuary',
              'description':
                  'Visit the famous Philippine tarsier and learn about its habitat.',
              'price': 500,
              'thumbnail':
                  'https://images.unsplash.com/photo-1549366021-9f761d450615',
              'category': 'Wildlife',
            },
            {
              'title': 'Panglao Island Tour',
              'description':
                  'Relax on the beautiful beaches of Panglao Island.',
              'price': 1800,
              'thumbnail':
                  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
              'category': 'Beach Tour',
            },
            {
              'title': 'Bohol Island Hopping',
              'description':
                  'Discover beautiful islands and enjoy swimming and snorkeling.',
              'price': 2000,
              'thumbnail':
                  'https://images.unsplash.com/photo-1544550285-f813152fb2fd',
              'category': 'Island Hopping',
            },
            {
              'title': 'Baclayon Church Tour',
              'description':
                  'Explore one of the oldest stone churches in Bohol.',
              'price': 800,
              'thumbnail':
                  'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
              'category': 'Heritage Tour',
            },
          ];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load products.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unable to connect to the API.';
      });
    }
  }

  // ======================================================
  // INIT STATE
  // ======================================================

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ======================================================
  // PRODUCT DETAILS
  // ======================================================

  void showProductDetails(Map product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product['thumbnail'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Text(
                product['description'],
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
              Text(
                'Category: ${product['category']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: ₱${product['price']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bohol Tours',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // ==================================================
      // BODY
      // ==================================================

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text(errorMessage),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = '';
                          });

                          fetchProducts();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          showProductDetails(product);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              // IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product['thumbnail'],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 35,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              // DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['title'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      product['category'],
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      product['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 7),

                                    Text(
                                      '₱${product['price']}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
