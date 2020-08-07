package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;

class RewindState extends FlxSubState
{
	private var parent:TheActualGameSubstate;
	private var rewindSprite:FlxSprite;

	public function new(parent:TheActualGameSubstate)
	{
		super(FlxColor.TRANSPARENT);
		this.parent = parent;
	}

	override function create()
	{
		super.create();
		FlxG.sound.play("assets/sounds/rewind.ogg");
		add(rewindSprite = new FlxSprite(0, 0).loadGraphic("assets/images/rewindtime.png"));
		rewindSprite.alpha = 0;
		FlxTween.num(0.0, 1.0, 1.0, {
			onComplete: (t) ->
			{
				new FlxTimer().start(1.0, (tm) ->
				{
					close();
					parent.restart();
				});
			}
		}, (f) ->
			{
				bgColor = FlxColor.fromRGBFloat(0, 0, 0, f);
				rewindSprite.alpha = f;
			});
	}
}
