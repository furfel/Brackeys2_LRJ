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
		loadGraphic("assets/images/room/player.png", true, 12, 18);
		animation.add("standdown", [0], 3);
		animation.add("walkdown", [1, 2], 5);
		animation.add("standup", [3], 3);
		animation.add("walkup", [4, 5], 5);
		animation.add("standright", [6], 3);
		animation.add("walkright", [7, 8], 5);
		animation.add("standleft", [9], 3);
		animation.add("walkleft", [10, 11], 5);
		animation.play("standleft");

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

	private var currentAnim = "standleft";

	private function updateAnim()
	{
		var direction = "down";
		if (velocity.x > 0.01)
		{
			direction = "right";
		}
		else if (velocity.x < -0.01)
		{
			direction = "left";
		}

		if (velocity.y > 0.01)
		{
			direction = "down";
		}
		else if (velocity.y < -0.01)
		{
			direction = "up";
		}

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

		updateAnim();
	}
}
