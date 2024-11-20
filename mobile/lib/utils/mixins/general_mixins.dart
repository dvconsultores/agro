import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sap_avicola/main_provider.dart';
import 'package:sap_avicola/utils/config/theme.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';

final _context = ContextUtility.context!;

mixin ThemesMixin {
  final colors = ThemeApp.colors(_context),
      styles = ThemeApp.styles(_context),
      theme = Theme.of(_context),
      media = MediaQuery.of(_context);
}

mixin ProviderMixin {
  final mainProvider = Provider.of<MainProvider>(_context, listen: false),
      mainProviderListenable = Provider.of<MainProvider>(_context);
}
