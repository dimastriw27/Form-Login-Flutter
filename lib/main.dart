import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang'),
        leading: Icon(Icons.local_activity_outlined),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan Email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan password';
              }
              return null;
            },
          ),
          SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                String username = _emailController.text;
                String password = _passwordController.text;

                if (username == 'dimastri@gmail.com' && password == 'password123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email atau Password anda salah.'),
                    ),
                  );
                }
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

// ...

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [
    Product(id: 1, name: 'Bando 08', price: 2000),
    Product(id: 2, name: 'Bando 2 cagak', price: 3000),
    Product(id: 3, name: 'Bando 20 DN', price: 1000),
    Product(id: 4, name: 'Bando 3 daun', price: 2000),
    Product(id: 5, name: 'Bando 30', price: 2000),
    Product(id: 6, name: 'Bando 35', price: 2000),
    Product(id: 7, name: 'Bando 47', price: 3000),
    Product(id: 8, name: 'Bando 50', price: 3000),
    Product(id: 9, name: 'Bando 75', price: 7000),
    Product(id: 10, name: 'Bando 90', price: 9000),
  ];

  List<Product> filteredProducts = [];

  @override
  void initState() {
    filteredProducts = products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(filteredProducts),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${filteredProducts[index].id}. ${filteredProducts[index].name}'),
            subtitle: Text('Harga: Rp. ${filteredProducts[index].price}'),
            contentPadding: EdgeInsets.only(left: 16.0, right: 0.0),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteProduct(filteredProducts[index].id);
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
            height: 2.0,
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              _showAddProductDialog();
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _deleteProduct(int productId) {
    setState(() {
      products.removeWhere((product) => product.id == productId);
      filteredProducts = products;
    });
  }

  void _showAddProductDialog() {
    String newName = '';
    String newPrice = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Produk Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nama Produk'),
                onChanged: (value) {
                  newName = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Harga (Rp)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newPrice = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _addProduct(newName, newPrice);
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct(String name, String price) {
    if (name.isNotEmpty && price.isNotEmpty) {
      int newId = products.length + 1;
      int newPrice = int.parse(price);
      Product newProduct = Product(id: newId, name: name, price: newPrice);
      setState(() {
        products.add(newProduct);
        filteredProducts = products;
      });
    }
  }
}

class Product {
  int id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});
}

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Product> searchResults = products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${searchResults[index].id}. ${searchResults[index].name}'),
          subtitle: Text('Harga: Rp. ${searchResults[index].price}'),
          onTap: () {
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestionList = products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${suggestionList[index].id}. ${suggestionList[index].name}'),
          subtitle: Text('Harga: Rp. ${suggestionList[index].price}'),
          onTap: () {
            query = suggestionList[index].name;
            close(context, suggestionList[index]);
          },
        );
      },
    );
  }
}