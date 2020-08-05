package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	private static final speed = 40;

	private var parent:TheActualGameSubstate;

	public function new(X:Float, Y:Float, state:TheActualGameSubstate)
	{
		super(X, Y);
		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8, true);

		animation.add(Std.string(FlxObject.RIGHT), [2], 3);
		animation.add(Std.string(FlxObject.LEFT), [2], 3, true, true);
		animation.add(Std.string(FlxObject.DOWN), [5], 3);
		animation.add(Std.string(FlxObject.UP), [8], 3);

		animation.add("walk" + Std.string(FlxObject.RIGHT), [1, 2], 5);
		animation.add("walk" + Std.string(FlxObject.LEFT), [1, 2], 5, true, true);
		animation.add("walk" + Std.string(FlxObject.DOWN), [3, 4], 5);
		animation.add("walk" + Std.string(FlxObject.UP), [6, 7], 5);

		animation.play(Std.string(FlxObject.DOWN));

		parent = state;

		setSize(6, 7);
		offset.set(1, 1);
	}

	private var up = false;
	private var down = false;
	private var left = false;
	private var right = false;

	private function getFloorSpeed():Float
	{
		if (parent != null)
		{
			var tile = parent.floors.getTile(Math.round(x / 8), Math.round(y / 8));
			if (tile == 24)
				return speed / 1.25;
		}
		return speed;
	}

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

	private var paralyzed = 0.0;

	public function hitAndParalyze(slime:FlxSprite)
	{
		if (paralyzed > 0)
			return;
		paralyzed = 0.4;
		var _angle = FlxAngle.angleBetween(this, slime, true);
		velocity.set(-speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (paralyzed > 0)
		{
			paralyzed -= elapsed;
			alpha = 0.7 + 0.1 * FlxMath.fastCos(paralyzed * 8.0);
			color = FlxColor.fromRGBFloat(0.8 + 0.2 * FlxMath.fastSin(paralyzed * 12.0), 0.25, 0.25);
			if (paralyzed <= 0)
			{
				alpha = 1;
				velocity.set(0, 0);
				color = FlxColor.WHITE;
			}
			return;
		}

		updateMovement();
		var angle = 0;
		if (up || down || left || right)
		{
			velocity.set(getFloorSpeed(), 0);

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
