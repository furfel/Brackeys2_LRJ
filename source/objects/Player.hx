package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public static final speed = 50;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		makeGraphic(8, 8, FlxColor.CYAN);
	}

	private var left = false;
	private var right = false;
	private var up = false;
	private var down = false;

	private function updateMovement()
	{
		#if js
		if (Main.html5gamepad.getAxis(0) > 0.5 || FlxG.keys.pressed.D)
		{
			right = true;
			left = false;
		}
		else if (Main.html5gamepad.getAxis(0) < -0.5 || FlxG.keys.pressed.A)
		{
			left = true;
			right = false;
		}
		else
		{
			left = false;
			right = false;
		}

		if (Main.html5gamepad.getAxis(1) > 0.5 || FlxG.keys.pressed.S)
		{
			down = true;
			up = false;
		}
		else if (Main.html5gamepad.getAxis(1) < -0.5 || FlxG.keys.pressed.W)
		{
			down = false;
			up = true;
		}
		else
		{
			down = false;
			up = false;
		}
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updateMovement();
		var angle = 0;
		if (up || down || left || right)
		{
			velocity.set(speed, 0);

			if ((up && down) || (!up && !down))
			{
				if (left && right)
					velocity.set(0, 0);
				else if (left)
					angle = 180;
				else if (right)
					angle = 0;
			}
			else if (up)
			{
				if ((left && right) || (!left && !right))
					angle = 270;
				else if (left)
					angle = 225;
				else if (right)
					angle = 315;
			}
			else if (down)
			{
				if ((left && right) || (!left && !right))
					angle = 90;
				else if (left)
					angle = 135;
				else if (right)
					angle = 45;
			}

			velocity.rotate(FlxPoint.weak(0, 0), angle);
		}
		else
			velocity.set(0, 0);
	}
}
