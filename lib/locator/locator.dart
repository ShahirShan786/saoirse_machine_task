import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../data/user_model/user_data.dart';
import 'app_db.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  /// setup hive
  final appDocumentDir = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();


  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(UserDataAdapter())
    ..registerAdapter(BankDetailAdapter())
    ..registerAdapter(KycDocumentAdapter())
    ..registerAdapter(SavedPlanAdapter())
    ..registerAdapter(WalletAdapter())
  ;
  locator.registerSingletonAsync<AppDB>(() => AppDB.getInstance());

/*  /// setup navigator instance
  locator.registerSingleton(AppRouter());

  /// setup API modules with repos which requires [Dio] instance
  await ApiModule().provides();

  /// setup encryption service
  locator.registerLazySingleton(
        () => EncService(aesKey: "WQXy4CzZyUyJNOr5z5mvcR13dwxBGKnr"),
  );

  /// register repositories implementation
  locator.registerFactory<AuthRepoImpl>(
        () => AuthRepoImpl(authApi: locator()),
  );

  /// register stores if only you requires singleton
  locator.registerLazySingleton<AuthStore>(() => AuthStore());*/
}
