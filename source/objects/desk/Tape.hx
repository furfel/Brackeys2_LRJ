package objects.desk;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Tape extends FocusableSprite
{
	private var point = new FlxPoint(0, 0);

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/desk/tape.png");
		point.set(this.x + this.width / 2, this.y + this.height / 2);
	}

	override function getPoint():FlxPoint
	{
		return point;
	}
}
