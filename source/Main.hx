package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.CasetteState;
import states.ComputerState;
import states.DeskState;
import states.PlayState;
import states.RoomState;

class Main extends Sprite
{
	#if js
	public static var html5gamepad = new HTML5Gamepad();
	#end

	public function new()
	{
		super();
		// For LOWREZJAM 64x64 scaled to 320x320 in browser
		// for visibility
		addChild(new FlxGame(64, 64, RoomState));
	}
}
