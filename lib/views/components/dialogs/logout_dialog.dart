import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone/views/constants/strings.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  LogoutDialog()
      : super(
          title: Strings.logOut,
          message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
          buttons: {
            Strings.cancel: false,
            Strings.logOut: true,
          },
        );
}
