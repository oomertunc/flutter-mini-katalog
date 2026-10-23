import 'package:flutter/material.dart';

void main() => runApp(const MiniKatalogApp());

class Product {
  final String name, category, description, emoji;
  final int price;
  const Product(this.name, this.category, this.description, this.emoji, this.price);
}

const products = <Product>[
  Product('Kablosuz Kulaklık', 'Elektronik', 'Gün boyu konforlu kullanım ve net ses.', '🎧', 1499),
  Product('Seramik Kupa', 'Ev ve Yaşam', 'Sabah kahven için sade ve kullanışlı kupa.', '☕', 249),
  Product('Keten Gömlek', 'Giyim', 'Hafif dokulu, rahat kesim günlük gömlek.', '👕', 899),
  Product('Tasarım Defteri', 'Kırtasiye', 'Fikirlerin için çizgisiz sayfalar.', '📓', 329),
  Product('Masa Lambası', 'Ev ve Yaşam', 'Çalışma masasına yumuşak ışık.', '💡', 1199),
  Product('Akıllı Saat', 'Elektronik', 'Aktivite takibi ve günlük bildirimler.', '⌚', 2799),
];

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(title: 'Mini Katalog', debugShowCheckedModeBanner: false, theme: ThemeData(colorSchemeSeed: const Color(0xff4169e1), useMaterial3: true), home: const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';
  final Set<String> cart = {};
  @override
  Widget build(BuildContext context) {
    final shown = products.where((p) => '${p.name} ${p.category}'.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(appBar: AppBar(title: const Text('Keşfet'), actions: [Padding(padding: const EdgeInsets.all(16), child: Badge(label: Text('${cart.length}'), child: const Icon(Icons.shopping_bag_outlined)))]), body: Column(children: [Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16), child: TextField(decoration: InputDecoration(hintText: 'Ürün veya kategori ara', prefixIcon: const Icon(Icons.search), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)), onChanged: (v) => setState(() => query = v))), Expanded(child: GridView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .70, crossAxisSpacing: 14, mainAxisSpacing: 14), itemCount: shown.length, itemBuilder: (context, i) { final p = shown[i]; return Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: p, onAdd: () => setState(() => cart.add(p.name)))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Container(color: const Color(0xffedf1fa), width: double.infinity, alignment: Alignment.center, child: Text(p.emoji, style: const TextStyle(fontSize: 58)))), Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.category, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.blueGrey)), const SizedBox(height: 4), Text(p.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text('${p.price} ₺', style: const TextStyle(fontWeight: FontWeight.w700))]))]))); })),]));
  }
}

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  const ProductDetailPage({super.key, required this.product, required this.onAdd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Ürün detayı')), body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Container(width: double.infinity, decoration: BoxDecoration(color: const Color(0xffedf1fa), borderRadius: BorderRadius.circular(28)), child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 100)))), const SizedBox(height: 24), Text(product.category.toUpperCase(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueGrey)), const SizedBox(height: 8), Text(product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 12), Text(product.description, style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 18), Text('${product.price} ₺', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { onAdd(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ürün sepete eklendi'))); }, icon: const Icon(Icons.add_shopping_cart), label: const Text('Sepete ekle'))])));
}
