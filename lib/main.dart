import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/core/utils/theme.dart';
import 'package:notely/splash_view.dart';
import 'package:notely/views/home.dart';
import 'package:notely/views/login.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


void main()async {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return ScreenUtilInit(
      designSize: isTablet ? Size(768, 979) : Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
        title: 'Notely',
        theme: CustomTheme.theme,
        navigatorKey: navigatorKey,
        home: SplashView()
      ),
    );
  }
}
