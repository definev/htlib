import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:htlib_admin/_internal/log.dart';
import 'package:htlib_admin/_internal/utils/utils.dart';
import 'package:time/time.dart';
import 'package:htlib_admin/commands/abstract_command.dart';

class BootstrapCommand extends AbstractCommand {
  BootstrapCommand(BuildContext c) : super(c);

  Future<void> execute() async {
    await Future.delayed(.5.seconds);

    /// Display startup logs
    Log.writeToDisk = false;
    Log.pHeader("BootstrapCommand");

    if (Utils.isDestop) {
      await DesktopWindow.setMinWindowSize(Size(500, 500));
    }

    Log.pFooter("BootstrapCommand");
  }
}
