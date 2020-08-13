package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public static final speed = 50;

	public function new(X:Float, Y:Float, direction:Int = FlxObject.LEFT)
	{
		super(X, Y);
		loadGraphic("assets/images/room/player.png", true, 12, 18);
		animation.add("stand" + Std.string(FlxObject.DOWN), [0], 3);
		animation.add("walk" + Std.string(FlxObject.DOWN), [1, 2], 5);
		animation.add("stand" + Std.string(FlxObject.UP), [3], 3);
		animation.add("walk" + Std.string(FlxObject.UP), [4, 5], 5);
		animation.add("stand" + Std.string(FlxObject.RIGHT), [6], 3);
		animation.add("walk" + Std.string(FlxObject.RIGHT), [7, 8], 5);
		animation.add("stand" + Std.string(FlxObject.LEFT), [9], 3);
		animation.add("walk" + Std.string(FlxObject.LEFT), [10, 11], 5);
		facing = direction;
		updateAnim();

		setSize(8, 12);
		offset.set(2, 6);
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

	private var currentAnim = "";

	private function updateAnim()
	{
		var direction = Std.string(facing);

		if (velocity.x > 0.01 || velocity.x < -0.01 || velocity.y > 0.01 || velocity.y < -0.01)
			direction = "walk" + direction;
		else
			direction = "stand" + direction;

		if (currentAnim != direction)
		{
			currentAnim = direction;
			animation.play(direction);
		}
	}

	public function freeze()
	{
		frozen = true;
	}

	public function unfreeze()
	{
		frozen = false;
	}

	private var frozen = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (frozen)
		{
			velocity.set(0, 0);
			return;
		}
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
