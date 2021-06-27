import 'dart:math';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class AnimationControls extends FlareController {
  FlutterActorArtboard _artboard;

  ActorAnimation _fillAnimation;

  ActorAnimation _iceboyMoveY;
  final List<FlareAnimationLayer> _baseAnimations = [];

  double _waterFill = 0.00;
  double _currentWaterFill = 0;
  double _smoothTime = 5;

  void initialize(FlutterActorArtboard artboard) {

    if (artboard.name.compareTo("Artboard") == 0) {
      _artboard = artboard;

      _fillAnimation = artboard.getAnimation("water up");
      _iceboyMoveY = artboard.getAnimation("iceboy_move_up");
    }
  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (artboard.name.compareTo("Artboard") == 0) {
      _currentWaterFill +=
          (_waterFill - _currentWaterFill) * min(1, elapsed * _smoothTime);
      _fillAnimation.apply(
          _currentWaterFill * _fillAnimation.duration, artboard, 1);
      _iceboyMoveY.apply(
          _currentWaterFill * _iceboyMoveY.duration, artboard, 1);
    }

    int len = _baseAnimations.length - 1;
    for (int i = len; i >= 0; i--) {
      FlareAnimationLayer layer = _baseAnimations[i];
      layer.time += elapsed;
      layer.mix = min(1.0, layer.time / 0.01);
      layer.apply(_artboard);

      if (layer.isDone) {
        _baseAnimations.removeAt(i);
      }
    }
    return true;
  }

  void playAnimation(String animName) {
    ActorAnimation animation = _artboard.getAnimation(animName);

    if (animation != null) {
      _baseAnimations.add(FlareAnimationLayer()
        ..name = animName
        ..animation = animation);
    }
  }

  void updateWaterPercent(double amt) {
    _waterFill = amt;
  }

  void resetWater() {
    _waterFill = 0;
  }
}