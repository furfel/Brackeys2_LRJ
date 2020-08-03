package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ComputerState extends FlxState
{
	private var screen:FlxSprite;

	override function create()
	{
		super.create();

		createScreen();

		FlxG.camera.fade(FlxColor.fromRGB(25, 25, 25), 0.2, true, () ->
		{
			startBootAnimation();
		});
	}

	private function startBootAnimation()
	{
		new FlxTimer().start(0.5, (t) ->
		{
			screen.animation.play("title");
			t.start(0.9, (t) ->
			{
				screen.animation.play("memory");
			});
		});
	}

	private function createScreen()
	{
		screen = new FlxSprite(0, 0).loadGraphic("assets/images/computer/boot.png", true, 64, 64);
		screen.animation.add("off", [0], 5);
		screen.animation.add("title", [1], 5);
		screen.animation.add("memory", [2], 5);
		screen.animation.add("tape", [3], 5);
		screen.animation.add("checksum", [4], 5);
		screen.animation.play("off");
		add(screen);
	}
}
