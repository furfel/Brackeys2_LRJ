package objects.desk;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FocusableSprite extends FlxSprite implements IFocusable
{
	private var tween:FlxTween = null;

	public function focus():Any
	{
		if (tween != null)
			tween.cancel();
		tween = FlxTween.color(this, 0.3, FlxColor.WHITE, FlxColor.ORANGE, {
			type: PINGPONG,
			ease: FlxEase.circIn
		});

		return null;
	}

	public function unfocus():Any
	{
		if (tween != null)
			tween.cancel();
		color = FlxColor.WHITE;

		return null;
	}

	public function getPoint():FlxPoint
	{
		return FlxPoint.weak(0, 0);
	}

	public function doAction(parentState:FlxState):Void {}

	public function fexists():Bool
	{
		return alive && exists;
	}
}
