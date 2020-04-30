

import 'package:flutter/cupertino.dart';

class Configuration with ChangeNotifier {
  String _link_pagina;
  String _link_playstore;
  String _link_terminos;
  String _link_facebook;

  String get link_pagina => _link_pagina;

  set link_pagina(String value) {
    _link_pagina = value;
    notifyListeners();
  }

  String get link_playstore => _link_playstore;

  set link_playstore(String value) {
    _link_playstore = value;
    notifyListeners();
  }

  String get link_terminos => _link_terminos;

  set link_terminos(String value) {
    _link_terminos = value;
    notifyListeners();
  }

  String get link_facebook => _link_facebook;

  set link_facebook(String value) {
    _link_facebook = value;
    notifyListeners();
  }


}