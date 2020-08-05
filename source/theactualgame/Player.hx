package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	private static final speed = 40;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);

		animation.add(Std.string(FlxObject.RIGHT), [2], 3);
		animation.add(Std.string(FlxObject.LEFT), [2], 3, true, true);
		animation.add(Std.string(FlxObject.DOWN), [5], 3);
		animation.add(Std.string(FlxObject.UP), [8], 3);

		animation.add("walk" + Std.string(FlxObject.RIGHT), [1, 2], 5);
		animation.add("walk" + Std.string(FlxObject.LEFT), [1, 2], 5, true, true);
		animation.add("walk" + Std.string(FlxObject.DOWN), [3, 4], 5);
		animation.add("walk" + Std.string(FlxObject.UP), [6, 7], 5);

		animation.play(Std.string(FlxObject.DOWN));

		setSize(6, 7);
		offset.set(1, 1);
	}

	private var up = false;
	private var down = false;
	private var left = false;
	private var right = false;

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

	private var currentAnim = "";

	private function updateAnim()
	{
		var direction = Std.string(facing);

		if (velocity.x > 0.01 || velocity.x < -0.01 || velocity.y > 0.01 || velocity.y < -0.01)
			direction = "walk" + direction;

		if (currentAnim != direction)
		{
			currentAnim = direction;
			animation.play(direction);
		}
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
				{
					facing = FlxObject.LEFT;
					angle = 180;
				}
				else if (right)
				{
					facing = FlxObject.RIGHT;
					angle = 0;
				}
			}
			else if (up)
			{
				facing = FlxObject.UP;
				if ((left && right) || (!left && !right))
					angle = 270;
				else if (left)
					angle = 225;
				else if (right)
					angle = 315;
			}
			else if (down)
			{
				facing = FlxObject.DOWN;
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

		updateAnim();
	}
}
