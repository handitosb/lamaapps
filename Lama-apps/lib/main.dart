import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:lama_app/app/app.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:path_provider/path_provider.dart';

///Main method that launches the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.openBox('database');
    print("WEB Enabled: => Hive Initiated");
  } else {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    await Hive.openBox('database');
    print("Mobile Enabled: => Hive Initiated");
  }
  TasksetRepository tasksetRepository = TasksetRepository();
  tasksetRepository.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await precacheSvgs();
  runApp(RepositoryProvider(
    create: (context) => tasksetRepository,
    child: LamaApp(),
  ));
}

///Precaches the svgs files.
///
///Especially important for the "MoneyTask" since the svgs would need
///a second to load otherwise which looks cheap and unprofessional.
Future<void> precacheSvgs() async {
  return Future.wait([
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/1_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/2_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/5_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/10_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/20_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/50_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/1_Euro.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/2_Euro.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/svg/lama_coin.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/svg/lama_head.svg'),
      null,
    ),
  ]);
}
