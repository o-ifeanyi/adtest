import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final startapp = StartAppSdk();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      startapp.setTestAdsEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: const Text('show ad'),
          onPressed: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const AlertDialog(
                    content: CircularProgressIndicator(),
                    actions: [],
                  );
                });
            await startapp.loadRewardedVideoAd(
              onAdNotDisplayed: () {
                debugPrint('onAdNotDisplayed: rewarded video');
              },
              onAdHidden: () {
                debugPrint('onAdHidden: rewarded video');
              },
              onVideoCompleted: () {
                debugPrint(
                    'onVideoCompleted: rewarded video completed, user gained a reward');
              },
            ).then((rewardedVideoAd) async {
              debugPrint('rewardedVideoAd: rewarded video');
              await rewardedVideoAd.show();
            }).onError<StartAppException>((ex, stackTrace) {
              debugPrint('StartAppException Error loading ad: ${ex.message}');
            }).onError((error, stackTrace) {
              debugPrint('onError loading Rewarded Video ad: $error');
            });
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
