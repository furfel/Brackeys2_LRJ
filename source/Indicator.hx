package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Indicator extends FlxTypedSpriteGroup<FlxSprite>
{
	private var actionIndicator:FlxSprite;
	private var listenIndicator:FlxSprite;

	public function new()
	{
		super(2, FlxG.height - 18);
		scrollFactor.set(0, 0);

		add(actionIndicator = new FlxSprite(0, 0).loadGraphic("assets/images/action.png", true, 16, 16));
		actionIndicator.animation.add("", [0, 0, 0, 0, 0, 1, 1, 1, 1, 1], 3);
		actionIndicator.animation.play("");
		actionIndicator.scrollFactor.set(0, 0);
		actionIndicator.alpha = 0;

		add(listenIndicator = new FlxSprite(0, 0).loadGraphic("assets/images/listen.png"));
		listenIndicator.scrollFactor.set(0, 0);
		listenIndicator.alpha = 0;
	}

	private var tween:FlxTween;

	public function showListen()
	{
		hide();
		show(listenIndicator);
	}

	public function showAction()
	{
		hide();
		show(actionIndicator);
	}

	private function show(t:FlxSprite)
	{
		if (tween != null)
			tween.cancel();
		t.alpha = 0.6;
		t.scale.set(1.1, 1.1);
		tween = FlxTween.tween(t, {alpha: 0.3, "scale.x": 0.9, "scale.y": 0.9}, 1.0, {ease: FlxEase.cubeInOut, type: PINGPONG});
	}

	public function hide()
	{
		if (tween != null)
			tween.cancel();
		listenIndicator.alpha = 0;
		actionIndicator.alpha = 0;
	}
}
