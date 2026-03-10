import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

/// Supabase client — tüm sayfalardan erişmek için.
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hfflsfbqrynvzwesidru.supabase.co',      // Örn: https://xxxxx.supabase.co
    anonKey: 'sb_publishable_Gzp0L-RiEXk80fluR0IwIg_6I2SRLJ3',   // Supabase → Settings → API → publishable key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

    return MaterialApp(
      title: 'Muhasebem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const HomeShellPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  int _currentIndex = 0;
  int _stocksRefreshKey = 0;
  int _productsRefreshKey = 0;
  int _salesRefreshKey = 0;

  List<Widget> get _pages => [
        OverviewPage(
          onGoToStocks: () {
            setState(() {
              _currentIndex = 1;
            });
          },
          onGoToSales: () {
            setState(() {
              _currentIndex = 3;
            });
          },
        ),
        StocksPage(key: ValueKey(_stocksRefreshKey)),
        ProductsPage(key: ValueKey(_productsRefreshKey)),
        SalesPage(key: ValueKey(_salesRefreshKey)),
      ];

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Genel Bakış';
      case 1:
        return 'Stoklar';
      case 2:
        return 'Ürünler';
      case 3:
        return 'Satışlar';
      default:
        return 'Hafif Muhasebe';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Stoklar',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Ürünler',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Satışlar',
          ),
        ],
      ),
      floatingActionButton: _buildFab(context, colorScheme),
    );
  }

  Widget? _buildFab(BuildContext context, ColorScheme colorScheme) {
    switch (_currentIndex) {
      case 1:
        return FloatingActionButton.extended(
          onPressed: () async {
            final added = await showDialog<bool>(
              context: context,
              builder: (context) => const StokEkleDialog(),
            );
            if (added == true && mounted) {
              setState(() => _stocksRefreshKey++);
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni stok'),
        );
      case 2:
        return FloatingActionButton.extended(
          onPressed: () async {
            final added = await showDialog<bool>(
              context: context,
              builder: (context) => const UrunEkleDialog(),
            );
            if (added == true && mounted) {
              setState(() => _productsRefreshKey++);
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni ürün'),
        );
      case 3:
        return FloatingActionButton.extended(
          onPressed: () async {
            final created = await showDialog<bool>(
              context: context,
              builder: (context) => const SatisOlusturDialog(),
            );
            if (created == true && mounted) {
              setState(() {
                _salesRefreshKey++;
                _stocksRefreshKey++;
              });
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni satış'),
        );
      default:
        return null;
    }
  }
}

/// Stok ekleme formu — Supabase `stok` tablosuna insert yapar.
class StokEkleDialog extends StatefulWidget {
  const StokEkleDialog({super.key});

  @override
  State<StokEkleDialog> createState() => _StokEkleDialogState();
}

class _StokEkleDialogState extends State<StokEkleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _adiController = TextEditingController();
  final _hacimController = TextEditingController(text: '0');
  final _adetController = TextEditingController(text: '1');
  final _maliyetController = TextEditingController(text: '0');
  bool _saving = false;

  @override
  void dispose() {
    _adiController.dispose();
    _hacimController.dispose();
    _adetController.dispose();
    _maliyetController.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final hacim = double.tryParse(_hacimController.text) ?? 0;
      final adet = int.tryParse(_adetController.text) ?? 0;
      final maliyet = double.tryParse(_maliyetController.text) ?? 0;
      final ad = _adiController.text.trim();

      // Aynı ada sahip bir stok varsa, üzerine ekle; yoksa yeni stok oluştur.
      final existing = await supabase
          .from('stok')
          .select('id, stok_hacim_gr, stok_adet, stok_maliyet')
          .eq('stok_adi', ad)
          .maybeSingle();

      if (existing != null) {
        final id = existing['id'] as String;
        final currentHacim =
            (existing['stok_hacim_gr'] ?? 0).toDouble();
        final currentAdet = (existing['stok_adet'] ?? 0).toInt();
        final currentMaliyet =
            (existing['stok_maliyet'] ?? 0).toDouble();

        await supabase.from('stok').update({
          'stok_hacim_gr': currentHacim + hacim,
          'stok_adet': currentAdet + adet,
          'stok_maliyet': currentMaliyet + maliyet,
        }).eq('id', id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$ad" stokuna ekleme yapıldı.')),
        );
      } else {
        await supabase.from('stok').insert({
          'stok_adi': ad,
          'stok_hacim_gr': hacim,
          'stok_adet': adet,
          'stok_maliyet': maliyet,
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yeni stok eklendi.')),
        );
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni stok ekle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _adiController,
                decoration: const InputDecoration(
                  labelText: 'Stok adı',
                  hintText: 'Örn: Un',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Stok adı gerekli' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hacimController,
                decoration: const InputDecoration(
                  labelText: 'Hacim (gr)',
                  hintText: '0',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (double.tryParse(v) == null) return 'Geçerli bir sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _adetController,
                decoration: const InputDecoration(
                  labelText: 'Adet',
                  hintText: '1',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return '0 veya pozitif sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _maliyetController,
                decoration: const InputDecoration(
                  labelText: 'Birim maliyet (₺)',
                  hintText: '0',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  if (double.tryParse(v) == null) return 'Geçerli bir sayı girin';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _kaydet,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}

/// Ürün ekleme formu — Supabase `urunler` tablosuna insert yapar.
class UrunEkleDialog extends StatefulWidget {
  const UrunEkleDialog({super.key});

  @override
  State<UrunEkleDialog> createState() => _UrunEkleDialogState();
}

class _UrunEkleDialogState extends State<UrunEkleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _adiController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _adiController.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      await supabase.from('urunler').insert({
        'urun_adi': _adiController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün eklendi.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni ürün ekle'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _adiController,
          decoration: const InputDecoration(
            labelText: 'Ürün adı',
            hintText: 'Örn: Ekmek',
          ),
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Ürün adı gerekli' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _kaydet,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}

/// Ürün reçetesi düzenleme — Supabase `urun_stok` tablosunu kullanır.
class ReceteDuzenleDialog extends StatefulWidget {
  final String urunId;
  final String urunAdi;

  const ReceteDuzenleDialog({
    super.key,
    required this.urunId,
    required this.urunAdi,
  });

  @override
  State<ReceteDuzenleDialog> createState() => _ReceteDuzenleDialogState();
}

class _ReceteDuzenleDialogState extends State<ReceteDuzenleDialog> {
  bool _loading = true;
  bool _saving = false;
  final _miktarController = TextEditingController();
  List<Map<String, dynamic>> _stoklar = [];
  List<Map<String, dynamic>> _receteSatirlari = [];
  String? _selectedStokId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _miktarController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final stokRes =
          await supabase.from('stok').select('id, stok_adi').order('stok_adi');
      final receteRes = await supabase
          .from('urun_stok')
          .select('id, kullanilan_miktar_gr, stok(stok_adi)')
          .eq('urun_id', widget.urunId);

      setState(() {
        _stoklar = List<Map<String, dynamic>>.from(stokRes);
        _receteSatirlari = List<Map<String, dynamic>>.from(receteRes);
        _selectedStokId ??=
            _stoklar.isNotEmpty ? _stoklar.first['id'] as String? : null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reçete yüklenemedi: $e')),
      );
    }
  }

  Future<void> _ekleSatir() async {
    if (_selectedStokId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce stok seçmelisin')),
      );
      return;
    }
    final miktar = double.tryParse(_miktarController.text.trim());
    if (miktar == null || miktar <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir miktar (gr) gir')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await supabase.from('urun_stok').insert({
        'urun_id': widget.urunId,
        'stok_id': _selectedStokId,
        'kullanilan_miktar_gr': miktar,
      });
      _miktarController.clear();
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satır eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _silSatir(String id) async {
    setState(() => _saving = true);
    try {
      await supabase.from('urun_stok').delete().eq('id', id);
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satır silinemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reçete · ${widget.urunAdi}'),
      content: _loading
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_receteSatirlari.isEmpty)
                    const Text('Bu ürün için henüz reçete yok.'),
                  if (_receteSatirlari.isNotEmpty)
                    ..._receteSatirlari.map(
                      (row) {
                        final stok = row['stok'];
                        final stokAdi =
                            stok is Map ? (stok['stok_adi'] as String? ?? '?') : '?';
                        final miktar = row['kullanilan_miktar_gr'];
                        final id = row['id'] as String?;
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('$stokAdi'),
                          subtitle: Text('$miktar gr'),
                          trailing: id == null
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: _saving ? null : () => _silSatir(id),
                                ),
                        );
                      },
                    ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Yeni satır ekle',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedStokId,
                    items: _stoklar
                        .map(
                          (s) => DropdownMenuItem<String>(
                            value: s['id'] as String?,
                            child: Text(s['stok_adi'] as String? ?? '?'),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (v) {
                            setState(() => _selectedStokId = v);
                          },
                    decoration: const InputDecoration(
                      labelText: 'Stok seç',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _miktarController,
                    decoration: const InputDecoration(
                      labelText: 'Kullanılan miktar (gr)',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Kapat'),
        ),
        FilledButton.icon(
          onPressed: _saving || _loading ? null : _ekleSatir,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add),
          label: const Text('Satır ekle'),
        ),
      ],
    );
  }
}

/// Yeni satış ekleme – ürün, adet, kâr oranı; kayıt listeye eklenir, stok düşümü listeden "Tamamla" ile yapılır.
class SatisOlusturDialog extends StatefulWidget {
  const SatisOlusturDialog({super.key});

  @override
  State<SatisOlusturDialog> createState() => _SatisOlusturDialogState();
}

class _SatisOlusturDialogState extends State<SatisOlusturDialog> {
  bool _loading = true;
  bool _saving = false;
  List<Map<String, dynamic>> _urunler = [];
  String? _selectedUrunId;
  final _adetController = TextEditingController(text: '1');
  final _karOraniController = TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    _loadUrunler();
  }

  @override
  void dispose() {
    _adetController.dispose();
    _karOraniController.dispose();
    super.dispose();
  }

  Future<void> _loadUrunler() async {
    try {
      final res = await supabase
          .from('urunler')
          .select('id, urun_adi')
          .order('urun_adi');
      setState(() {
        _urunler = List<Map<String, dynamic>>.from(res);
        _selectedUrunId =
            _urunler.isNotEmpty ? _urunler.first['id'] as String? : null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürünler yüklenemedi: $e')),
      );
    }
  }

  /// Sadece satış kaydı ekler (tamamlandi: false). Stok düşümü listeden "Tamamla" ile yapılır.
  Future<void> _satisEkle() async {
    final urunId = _selectedUrunId;
    if (urunId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce bir ürün seçmelisin')),
      );
      return;
    }
    final adet = int.tryParse(_adetController.text.trim());
    if (adet == null || adet <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir adet gir (1 veya daha büyük)')),
      );
      return;
    }
    final karOraniYuzde = double.tryParse(_karOraniController.text.trim());
    if (karOraniYuzde == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Geçerli bir kâr oranı (%) girmelisin')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final recete = await supabase
          .from('urun_stok')
          .select('stok_id, kullanilan_miktar_gr')
          .eq('urun_id', urunId);
      final receteList = List<Map<String, dynamic>>.from(recete);

      double toplamMaliyet = 0;
      for (final row in receteList) {
        final stokId = row['stok_id'] as String?;
        if (stokId == null) continue;
        final miktarGr = (row['kullanilan_miktar_gr'] ?? 0).toDouble();
        final toplamKullanilan = miktarGr * adet;
        final stokRow = await supabase
            .from('stok')
            .select('stok_hacim_gr, stok_maliyet')
            .eq('id', stokId)
            .maybeSingle();
        if (stokRow == null) continue;
        final stokHacim = (stokRow['stok_hacim_gr'] ?? 0).toDouble();
        final stokMaliyet = (stokRow['stok_maliyet'] ?? 0).toDouble();
        if (stokHacim > 0) {
          toplamMaliyet += (stokMaliyet / stokHacim) * toplamKullanilan;
        }
      }

      final kazanilan = toplamMaliyet * (1 + karOraniYuzde / 100.0);

      await supabase.from('gecmis_satis').insert({
        'urun_id': urunId,
        'adet': adet,
        'satis_kazanilan': kazanilan,
        'tamamlandi': false,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Satış eklendi. Tutar: ₺ ${kazanilan.toStringAsFixed(2)}. '
            'Geçmiş satışlar listesinden "Tamamla" ile stok düşümünü yapabilirsin.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satış eklenemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni satış'),
      content: _loading
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedUrunId,
                  items: _urunler
                      .map(
                        (u) => DropdownMenuItem<String>(
                          value: u['id'] as String?,
                          child: Text(u['urun_adi'] as String? ?? 'Adsız ürün'),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (v) {
                          setState(() => _selectedUrunId = v);
                        },
                  decoration: const InputDecoration(
                    labelText: 'Ürün seç',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _adetController,
                  decoration: const InputDecoration(
                    labelText: 'Adet',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _karOraniController,
                  decoration: const InputDecoration(
                    labelText: 'Kâr oranı (%)',
                    hintText: 'Örn: 20',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving || _loading ? null : _satisEkle,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Satış ekle'),
        ),
      ],
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({
    super.key,
    required this.onGoToStocks,
    required this.onGoToSales,
  });

  final VoidCallback onGoToStocks;
  final VoidCallback onGoToSales;

  Future<List<({DateTime day, double total})>> _fetchLast30DaysSales() async {
    final now = DateTime.now().toUtc();
    final startOfToday = DateTime.utc(now.year, now.month, now.day);
    final start = startOfToday.subtract(const Duration(days: 29));
    final end = startOfToday.add(const Duration(days: 1));

    final rows = await supabase
        .from('gecmis_satis')
        .select('satis_tarih, satis_kazanilan')
        .gte('satis_tarih', start.toIso8601String())
        .lt('satis_tarih', end.toIso8601String());

    final Map<DateTime, double> totalsByDay = {};
    for (final raw in List<Map<String, dynamic>>.from(rows)) {
      final iso = raw['satis_tarih'] as String?;
      if (iso == null) continue;
      DateTime dt;
      try {
        dt = DateTime.parse(iso).toUtc();
      } catch (_) {
        continue;
      }
      final dayKey = DateTime.utc(dt.year, dt.month, dt.day);
      final amount = (raw['satis_kazanilan'] ?? 0).toDouble();
      totalsByDay.update(dayKey, (v) => v + amount, ifAbsent: () => amount);
    }

    final List<({DateTime day, double total})> result = [];
    for (int i = 0; i < 30; i++) {
      final d = start.add(Duration(days: i));
      result.add((day: d, total: totalsByDay[d] ?? 0.0));
    }
    return result;
  }

  Future<
      ({
        double totalStock,
        double todaySales,
        double weekSales,
        double monthSales,
        int productCount
      })> _fetchOverview() async {
    final now = DateTime.now().toUtc();
    final startOfToday = DateTime.utc(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));

    // Haftanın başlangıcı (Pazartesi)
    final startOfWeek =
        startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
    // Ayın başlangıcı
    final startOfMonth = DateTime.utc(now.year, now.month, 1);

    final stokList =
        await supabase.from('stok').select('stok_maliyet, stok_adet');
    double totalStock = 0;
    for (final row in List<Map<String, dynamic>>.from(stokList)) {
      final m = (row['stok_maliyet'] ?? 0).toDouble();
      final a = (row['stok_adet'] ?? 0).toInt();
      totalStock += m * a;
    }

    final todaySalesList = await supabase
        .from('gecmis_satis')
        .select('satis_kazanilan')
        .gte('satis_tarih', startOfToday.toIso8601String())
        .lt('satis_tarih', endOfToday.toIso8601String());
    double todaySales = 0;
    for (final row in List<Map<String, dynamic>>.from(todaySalesList)) {
      todaySales += (row['satis_kazanilan'] ?? 0).toDouble();
    }

    final weekSalesList = await supabase
        .from('gecmis_satis')
        .select('satis_kazanilan')
        .gte('satis_tarih', startOfWeek.toIso8601String())
        .lt('satis_tarih', endOfToday.toIso8601String());
    double weekSales = 0;
    for (final row in List<Map<String, dynamic>>.from(weekSalesList)) {
      weekSales += (row['satis_kazanilan'] ?? 0).toDouble();
    }

    final monthSalesList = await supabase
        .from('gecmis_satis')
        .select('satis_kazanilan')
        .gte('satis_tarih', startOfMonth.toIso8601String())
        .lt('satis_tarih', endOfToday.toIso8601String());
    double monthSales = 0;
    for (final row in List<Map<String, dynamic>>.from(monthSalesList)) {
      monthSales += (row['satis_kazanilan'] ?? 0).toDouble();
    }

    final urunlerList = await supabase.from('urunler').select('id');
    final productCount = (urunlerList as List).length;

    return (
      totalStock: totalStock,
      todaySales: todaySales,
      weekSales: weekSales,
      monthSales: monthSales,
      productCount: productCount
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(
              height: 220,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Son 30 gün kazanç grafiği',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: FutureBuilder<
                            List<({DateTime day, double total})>>(
                          future: _fetchLast30DaysSales(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Grafik yüklenemedi',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error,
                                  ),
                                ),
                              );
                            }
                            final data = snapshot.data ?? [];
                            if (data.isEmpty) {
                              return const Center(
                                child: Text('Henüz satış verisi yok.'),
                              );
                            }

                            final spots = <FlSpot>[];
                            double maxY = 0;
                            for (int i = 0; i < data.length; i++) {
                              final v = data[i].total;
                              spots.add(FlSpot(i.toDouble(), v));
                              if (v > maxY) maxY = v;
                            }
                            if (maxY == 0) maxY = 1;

                            return LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border(
                                    left: BorderSide(color: Colors.black12),
                                    bottom: BorderSide(color: Colors.black12),
                                    right: BorderSide(color: Colors.transparent),
                                    top: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: maxY / 4,
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 7,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.round();
                                        if (index < 0 ||
                                            index >= data.length) {
                                          return const SizedBox.shrink();
                                        }
                                        final d = data[index].day;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            '${d.day}.${d.month}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    barWidth: 3,
                                    dotData: FlDotData(show: false),
                                  ),
                                ],
                                minX: 0,
                                maxX: (data.length - 1).toDouble(),
                                minY: 0,
                                maxY: maxY,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Finansal özet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Stok ve kazanç durumunun kısa özeti',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            FutureBuilder<
                ({
                  double totalStock,
                  double todaySales,
                  double weekSales,
                  double monthSales,
                  int productCount
                })>(
              future: _fetchOverview(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Özet yüklenemedi: ${snapshot.error}',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }
                final o = snapshot.data ??
                    (
                      totalStock: 0.0,
                      todaySales: 0.0,
                      weekSales: 0.0,
                      monthSales: 0.0,
                      productCount: 0
                    );
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(
                      title: 'Toplam stok maliyeti',
                      value: '₺ ${o.totalStock.toStringAsFixed(2)}',
                      subtitle: '',
                    ),
                    _StatCard(
                      title: 'Günlük kazanç',
                      value: '₺ ${o.todaySales.toStringAsFixed(2)}',
                      subtitle: '',
                    ),
                    _StatCard(
                      title: 'Haftalık kazanç',
                      value: '₺ ${o.weekSales.toStringAsFixed(2)}',
                      subtitle: '',
                    ),
                    _StatCard(
                      title: 'Aylık kazanç',
                      value: '₺ ${o.monthSales.toStringAsFixed(2)}',
                      subtitle: '',
                    ),
                    _StatCard(
                      title: 'Aktif ürün sayısı',
                      value: '${o.productCount}',
                      subtitle: '',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Hızlı aksiyonlar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onGoToStocks,
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Stok ekle'),
                ),
                FilledButton.icon(
                  onPressed: onGoToSales,
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Satış ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData _pickIcon() {
      if (title.contains('stok')) return Icons.inventory_2_rounded;
      if (title.contains('Günlük')) return Icons.today_rounded;
      if (title.contains('Haftalık')) return Icons.date_range_rounded;
      if (title.contains('Aylık')) return Icons.calendar_month_rounded;
      if (title.contains('ürün')) return Icons.category_rounded;
      return Icons.info_outline_rounded;
    }

    final cardColor = theme.colorScheme.surfaceVariant.withOpacity(0.9);

    return SizedBox(
      width: 260,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor,
                theme.colorScheme.surface.withOpacity(0.9),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _pickIcon(),
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StocksPage extends StatefulWidget {
  const StocksPage({super.key});

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  Future<List<Map<String, dynamic>>> _fetchStocks() async {
    final response = await supabase.from('stok').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _deleteStock(Map<String, dynamic> row) async {
    final stokId = row['id'] as String?;
    if (stokId == null) return;

    final name = row['stok_adi'] as String? ?? 'Adsız stok';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stok kalemini sil'),
        content: Text(
          '"$name" stokunu silmek istediğine emin misin?\nBu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.from('stok').delete().eq('id', stokId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$name" stoğu silindi.')),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok silinemedi: $e')),
      );
    }
  }

  Future<void> _showIncreaseDialog(Map<String, dynamic> row) async {
    final stokId = row['id'] as String?;
    if (stokId == null) return;

    final name = row['stok_adi'] as String? ?? 'Adsız stok';
    final hacimController = TextEditingController(text: '0');
    final adetController = TextEditingController(text: '0');
    final maliyetController = TextEditingController(text: '0');
    bool saving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            Future<void> kaydet() async {
              if (saving) return;
              setLocalState(() => saving = true);
              try {
                final ekHacimBirim =
                    double.tryParse(hacimController.text.trim()) ?? 0;
                final ekAdet =
                    int.tryParse(adetController.text.trim()) ?? 0;
                final ekMaliyetBirim =
                    double.tryParse(maliyetController.text.trim()) ?? 0;

                // Kullanıcı birim değerleri giriyor; toplam etkiyi hesaplatalım.
                final ekHacimToplam = ekHacimBirim * ekAdet;
                final ekMaliyetToplam = ekMaliyetBirim * ekAdet;

                final mevcut = await supabase
                    .from('stok')
                    .select('stok_hacim_gr, stok_adet, stok_maliyet')
                    .eq('id', stokId)
                    .maybeSingle();

                if (mevcut == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Stok bulunamadı, sayfayı yenileyin.'),
                    ),
                  );
                  return;
                }

                final currentHacim =
                    (mevcut['stok_hacim_gr'] ?? 0).toDouble();
                final currentAdet = (mevcut['stok_adet'] ?? 0).toInt();
                final currentMaliyet =
                    (mevcut['stok_maliyet'] ?? 0).toDouble();

                await supabase.from('stok').update({
                  'stok_hacim_gr': currentHacim + ekHacimToplam,
                  'stok_adet': currentAdet + ekAdet,
                  'stok_maliyet': currentMaliyet + ekMaliyetToplam,
                }).eq('id', stokId);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '"$name" stokuna '
                      '${ekAdet} adet · ${ekHacimToplam.toStringAsFixed(1)} gr eklendi.',
                    ),
                  ),
                );
                setState(() {});
                Navigator.of(context).pop();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stok artırılamadı: $e')),
                );
              } finally {
                if (mounted) {
                  setLocalState(() => saving = false);
                }
              }
            }

            return AlertDialog(
              title: Text('"$name" stokunu artır'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: hacimController,
                      decoration: const InputDecoration(
                        labelText: 'Birim hacim (gr)',
                        hintText: 'Örn: 5000 (1 çuval)',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: adetController,
                      decoration: const InputDecoration(
                        labelText: 'Eklenen adet',
                        hintText: 'Örn: 2',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: maliyetController,
                      decoration: const InputDecoration(
                        labelText: 'Birim maliyet (₺)',
                        hintText: 'Örn: 300 (1 çuval fiyatı)',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                FilledButton.icon(
                  onPressed: saving ? null : kaydet,
                  icon: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: const Text('Stoka ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stok kalemlerin',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchStocks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Hata: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data ?? [];

                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz stok kaydı yok.\nSupabase’te "stok" tablosuna satır ekleyebilirsin.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final row = data[index];
                      final stokAdi =
                          row['stok_adi'] as String? ?? 'Adsız stok';
                      final hacim = row['stok_hacim_gr'] ?? 0;
                      final adet = row['stok_adet'] ?? 0;
                      final maliyet =
                          (row['stok_maliyet'] ?? 0).toDouble();

                      return Card(
                        child: ListTile(
                          title: Text(stokAdi),
                          subtitle: Text(
                            'Toplam hacim: $hacim gr · Adet: $adet',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₺ ${maliyet.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                tooltip: 'Bu stoğa ekle',
                                onPressed: () => _showIncreaseDialog(row),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Bu stoğu sil',
                                onPressed: () => _deleteStock(row),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  Future<List<Map<String, dynamic>>> _fetchProductsWithRecipe() async {
    final products = await supabase.from('urunler').select();
    final recipeRows = await supabase
        .from('urun_stok')
        .select('urun_id, kullanilan_miktar_gr, stok(stok_adi, stok_hacim_gr, stok_maliyet)');

    final productList = List<Map<String, dynamic>>.from(products);
    final recipeList = List<Map<String, dynamic>>.from(recipeRows);

    final Map<String, List<String>> recipeByUrunId = {};
    final Map<String, double> costByUrunId = {};
    final Map<String, bool> depletedByUrunId = {};
    for (final row in recipeList) {
      final urunId = row['urun_id'] as String?;
      if (urunId == null) continue;
      final gr = (row['kullanilan_miktar_gr'] ?? 0).toDouble();
      final stok = row['stok'];
      String stokAdi = '?';
      double stokHacimGr = 0;
      double stokMaliyet = 0;
      if (stok is Map) {
        stokAdi = stok['stok_adi'] as String? ?? '?';
        stokHacimGr = (stok['stok_hacim_gr'] ?? 0).toDouble();
        stokMaliyet = (stok['stok_maliyet'] ?? 0).toDouble();
      }

      // Reçete metni
      recipeByUrunId.putIfAbsent(urunId, () => []).add('$stokAdi: ${gr.toStringAsFixed(1)} gr');

      // Maliyet hesabı: stok_maliyet stok_hacim_gr gram için ödenen toplam para ise,
      // gram başı maliyet = stok_maliyet / stok_hacim_gr
      if (stokHacimGr > 0) {
        final birimMaliyet = stokMaliyet / stokHacimGr;
        final satirMaliyeti = birimMaliyet * gr;
        costByUrunId.update(urunId, (v) => v + satirMaliyeti, ifAbsent: () => satirMaliyeti);
      } else {
        // Stokta gram yoksa, tek bir ürün bile üretilemez → tükenen ürün var.
        depletedByUrunId[urunId] = true;
      }

      // Eğer stok miktarı, 1 adet ürün için gereken gr'dan azsa da uyarı say.
      if (stokHacimGr > 0 && stokHacimGr < gr) {
        depletedByUrunId[urunId] = true;
      }
    }

    for (final p in productList) {
      final id = p['id'] as String?;
      p['_recipe'] = id != null
          ? (recipeByUrunId[id]?.join(' · ') ?? 'Reçete yok')
          : 'Reçete yok';
      p['_cost'] = id != null ? (costByUrunId[id] ?? 0) : 0;
      p['_hasDepleted'] = id != null ? (depletedByUrunId[id] ?? false) : false;
    }
    return productList;
  }

  Future<void> _deleteProduct(
    BuildContext context,
    String urunId,
    String urunAdi,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ürünü sil'),
        content: Text(
          '"$urunAdi" ürününü silmek istediğine emin misin?\n'
          'Bu ürüne ait reçete satırları da silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Önce bu ürüne bağlı satış kayıtlarını sil
      await supabase.from('gecmis_satis').delete().eq('urun_id', urunId);
      // Sonra reçete satırlarını sil
      await supabase.from('urun_stok').delete().eq('urun_id', urunId);
      // En son ürünü sil
      await supabase.from('urunler').delete().eq('id', urunId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$urunAdi" silindi.')),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün silinemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ürünlerin',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchProductsWithRecipe(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Hata: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data ?? [];
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz ürün yok.\nSupabase’te "urunler" tablosuna kayıt ekleyebilirsin.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final row = data[index];
                      final ad = row['urun_adi'] as String? ?? 'Adsız ürün';
                      final recipe = row['_recipe'] as String? ?? 'Reçete yok';
                      final maliyet = (row['_cost'] ?? 0).toDouble();
                      final hasDepleted = (row['_hasDepleted'] ?? false) as bool;
                      final urunId = row['id'] as String?;
                      return Card(
                        child: ListTile(
                          title: Text(ad),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reçete: $recipe'),
                              const SizedBox(height: 4),
                              Text(
                                'Tahmini maliyet: ₺ ${maliyet.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (hasDepleted) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Tükenen ürünler var',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.red),
                                ),
                              ],
                            ],
                          ),
                          trailing: urunId == null
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_note),
                                      tooltip: 'Reçete düzenle',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ReceteDuzenleDialog(
                                            urunId: urunId,
                                            urunAdi: ad,
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      tooltip: 'Ürünü sil',
                                      onPressed: () =>
                                          _deleteProduct(context, urunId, ad),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late Future<List<Map<String, dynamic>>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = _fetchSales();
  }

  Future<List<Map<String, dynamic>>> _fetchSales() async {
    final response = await supabase
        .from('gecmis_satis')
        .select('*, urunler(urun_adi)')
        .order('satis_tarih', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  void _refreshSales() {
    setState(() {
      _salesFuture = _fetchSales();
    });
  }

  static String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(dt.year, dt.month, dt.day);
      if (d == today) {
        return 'Bugün ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      final yesterday = today.subtract(const Duration(days: 1));
      if (d == yesterday) {
        return 'Dün ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return '${dt.day}.${dt.month}.${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  /// Bu satış kaydı için stok düşümü yapıp tamamlandi=true yapar.
  Future<void> _tamamlaSatisRow(
    BuildContext context,
    Map<String, dynamic> row,
  ) async {
    final satisId = row['id'] as String?;
    final urunId = row['urun_id'] as String?;
    final adet = (row['adet'] ?? 1) as int;
    if (satisId == null || urunId == null) return;

    try {
      final recete = await supabase
          .from('urun_stok')
          .select('stok_id, kullanilan_miktar_gr')
          .eq('urun_id', urunId);
      final receteList = List<Map<String, dynamic>>.from(recete);

      final List<String> yetersizStoklar = [];
      for (final receteRow in receteList) {
        final stokId = receteRow['stok_id'] as String?;
        if (stokId == null) continue;
        final miktarGr = (receteRow['kullanilan_miktar_gr'] ?? 0).toDouble();
        final toplamKullanilan = miktarGr * adet;
        final stokRow = await supabase
            .from('stok')
            .select('stok_adi, stok_hacim_gr')
            .eq('id', stokId)
            .maybeSingle();
        if (stokRow == null) continue;
        final stokAdi = stokRow['stok_adi'] as String? ?? '?';
        final mevcut = (stokRow['stok_hacim_gr'] ?? 0).toDouble();
        if (mevcut < toplamKullanilan) {
          yetersizStoklar.add(
            '$stokAdi (gerekli: ${toplamKullanilan.toStringAsFixed(1)} gr, mevcut: ${mevcut.toStringAsFixed(1)} gr)',
          );
        }
      }

      if (yetersizStoklar.isNotEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Stok yetersiz:\n${yetersizStoklar.join('\n')}',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      for (final receteRow in receteList) {
        final stokId = receteRow['stok_id'] as String?;
        if (stokId == null) continue;
        final miktarGr = (receteRow['kullanilan_miktar_gr'] ?? 0).toDouble();
        final toplamKullanilan = miktarGr * adet;
        final stokRow = await supabase
            .from('stok')
            .select('stok_hacim_gr')
            .eq('id', stokId)
            .maybeSingle();
        if (stokRow == null) continue;
        final mevcut = (stokRow['stok_hacim_gr'] ?? 0).toDouble();
        final yeni = (mevcut - toplamKullanilan).clamp(0, double.infinity);
        await supabase
            .from('stok')
            .update({'stok_hacim_gr': yeni}).eq('id', stokId);
      }

      await supabase
          .from('gecmis_satis')
          .update({'tamamlandi': true}).eq('id', satisId);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Satış tamamlandı, stok düşüldü.')),
      );
      _refreshSales();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tamamlanamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geçmiş satışlar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _salesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Hata: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data ?? [];
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henüz satış kaydı yok. Yeni satış ile ekleyebilirsin.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final row = data[index];
                      final urunler = row['urunler'];
                      final urunAdi = urunler is Map
                          ? (urunler['urun_adi'] as String? ?? '—')
                          : '—';
                      final adet = row['adet'] ?? 1;
                      final kazanc =
                          (row['satis_kazanilan'] ?? 0).toDouble();
                      final tarih =
                          _formatDate(row['satis_tarih'] as String?);
                      final tamamlandi = row['tamamlandi'] == true;

                      return Card(
                        child: ListTile(
                          title: Text('$urunAdi · $adet adet'),
                          subtitle: Text(tarih),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₺ ${kazanc.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!tamamlandi) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () =>
                                      _tamamlaSatisRow(context, row),
                                  icon: const Icon(Icons.check),
                                  tooltip: 'Satışı tamamla',
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

