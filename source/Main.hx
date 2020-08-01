package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		// For LOWREZJAM 64x64 scaled to 320x320 in browser
		// for visibility
		addChild(new FlxGame(64, 64, PlayState));
	}
}
