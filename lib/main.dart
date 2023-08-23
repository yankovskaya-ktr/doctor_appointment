import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/src/application/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'provider_logger.dart';
import 'router.dart';
import 'src/data/auth_repo.dart';
import 'src/data/user_repo.dart';

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

Future<void> main() async {
  // Firebase app initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Cloud Messaging initialization
  await NotificationsService.init();

  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final fcmToken = ref.watch(fCMTokenProvider).asData?.value;
    final userRepo = ref.watch(userRepositoryProvider);
    // send user's token for notifications to firestore
    if (currentUser != null && fcmToken != null) {
      userRepo.addFCMToken(currentUser.id!, fcmToken);
    }

    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
        routerConfig: goRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context)
                      .primaryColorDark)), // Theme.of(context).textTheme.titleLarge),
          textTheme: const TextTheme(
            labelLarge: TextStyle(color: Colors.black54),
            labelMedium: TextStyle(color: Colors.black54),
            labelSmall: TextStyle(color: Colors.black54),
          ),
        ));
  }
}
