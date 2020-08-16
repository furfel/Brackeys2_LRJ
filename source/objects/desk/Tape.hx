package objects.desk;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import states.DeskState;

class Tape extends FocusableSprite
{
	private var point = new FlxPoint(0, 0);

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/desk/tape.png", true, 27, 27);
		animation.add("notape", [0], 5);
		animation.add("tape", [1], 5);
		animation.play("notape");
		point.set(this.x + this.width / 2, this.y + this.height / 2);
	}

	override function getPoint():FlxPoint
	{
		return point;
	}

	override function doAction(parentState:FlxState)
	{
		if ((parentState is DeskState))
		{
			var state = cast(parentState, DeskState);
			if (state.cassetteDone)
			{
				state.tapeDone = true;
				state.cassette.exists = false;
				animation.play("tape");
			}
		}
	}
}
