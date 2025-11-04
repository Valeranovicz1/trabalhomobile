import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/utils/app_colors.dart';
import 'package:projetomobile/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projetomobile/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/movie_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';
import 'package:projetomobile/viewmodels/home_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('pt_BR', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MovieViewModel()),
        ChangeNotifierProvider(create: (_) => RatingViewModel()),
        ChangeNotifierProxyProvider2<
          MovieViewModel,
          RatingViewModel,
          HomeViewModel
        >(
          create: (context) => HomeViewModel(
            Provider.of<MovieViewModel>(context, listen: false),
            Provider.of<RatingViewModel>(context, listen: false),
          ),
          update:
              (
                context,
                movieViewModel,
                ratingViewModel,
                previousHomeViewModel,
              ) {
                return HomeViewModel(movieViewModel, ratingViewModel);
              },
        ),
      ],
      child: const MovieDexApp(),
    ),
  );
}
