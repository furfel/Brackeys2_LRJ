package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		add(new FlxSprite(4, 4).makeGraphic(32, 32, FlxColor.RED));
		trace("text");

		trace("Breakpoint");

		trace("Bp2");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
