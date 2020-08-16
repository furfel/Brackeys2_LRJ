package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import states.CasetteState;
import states.ComputerState;
import states.DeskState;
import states.PlayState;
import states.RoomState;
import theactualgame.TheActualGameSubstate2;

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
		// addChild(new FlxGame(64, 64, ComputerState, true));
		addChild(new FlxGame(64, 64, RoomState, true));
	}

	public static function xcel(column:String):Int
	{
		return (column.length > 1) ? (column.toLowerCase()
			.charCodeAt(0) - 'a'.code) * ('z'.code - 'a'.code) + column.toLowerCase().charCodeAt(1) - 'a'.code : column.toLowerCase().charCodeAt(0)
			- 'a'.code;
	}
}
