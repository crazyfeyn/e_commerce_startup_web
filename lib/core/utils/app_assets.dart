class AppAssets {
  static AppIcons icons = const AppIcons();
  static AppImages images = const AppImages();
  static AppVideos videos = const AppVideos();

  const AppAssets._();
}

class AppIcons {
  const AppIcons();

  final String flagUs = 'assets/icons/flag_us.svg';
  final String flagKo = 'assets/icons/flag_ko.svg';
  final String icClose = 'assets/icons/ic_close.svg';

  final String home = 'assets/icons/home.svg';
  final String cart = 'assets/icons/saved.svg';
  final String person = 'assets/icons/person.svg';
}

class AppImages {
  const AppImages();

  final String appLogoCircle = 'assets/images/im_test.png';
  final String meatImage = 'assets/images/meat.png';
}

class AppVideos {
  const AppVideos();

  final String intro = 'assets/videos/test.mp4';
}
