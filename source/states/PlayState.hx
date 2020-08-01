package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState
{
	private var player:Player;

	override public function create()
	{
		super.create();

		add(player = new Player(30, 30));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
