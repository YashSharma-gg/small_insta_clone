import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/state/views/components/loading/loading_screen_controller.dart';

import '../constants/strings.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.maybeOf(context);
    if (state == null) {
      return null;
    }
    final textController = StreamController<String>();
    textController.add(text);

    // Getting screen size
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    //Overlay Loading
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<String>(
                      stream: textController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.requireData,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black,
                                ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Inserting our overlay in state
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
