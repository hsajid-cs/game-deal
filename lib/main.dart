import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/saved_deals_viewmodel.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = StorageService();
  await storageService.initHive();
  
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  
  const MyApp({Key? key, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<StorageService>(create: (_) => storageService),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            apiService: context.read<ApiService>(),
            storageService: context.read<StorageService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedDealsViewModel(
            storageService: context.read<StorageService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Game Deals',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeView(),
      ),
    );
  }
}