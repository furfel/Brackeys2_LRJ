package objects.desk;

import flixel.math.FlxPoint;

interface IFocusable
{
	public function focus():Any;
	public function unfocus():Any;
	public function getPoint():FlxPoint;
}
