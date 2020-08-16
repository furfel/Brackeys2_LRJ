package objects.desk;

import flixel.FlxState;
import flixel.math.FlxPoint;

interface IFocusable
{
	public function focus():Any;
	public function unfocus():Any;
	public function getPoint():FlxPoint;
	public function doAction(parentState:FlxState):Void;
	public function fexists():Bool;
}
