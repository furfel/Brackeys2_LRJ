package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	private static final speed = 40;

	private var walkSoundGround:FlxSound;
	private var walkSoundStone:FlxSound;

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

		walkSoundGround = new FlxSound().loadEmbedded("assets/sounds/steps1.ogg", true);
		walkSoundStone = new FlxSound().loadEmbedded("assets/sounds/steps2.ogg", true);

		parent = state;

		setSize(6, 7);
		offset.set(1, 1);

		health = 25.0;
	}

	private function stopSounds()
	{
		walkSoundGround.stop();
		walkSoundStone.stop();
	}

	private function updateSoundFromSpeed(speed:Float)
	{
		if (speed >= 39.0)
		{
			if (!walkSoundStone.playing)
			{
				stopSounds();
				walkSoundStone.play();
			}
		}
		else if (speed < 39.0)
		{
			if (!walkSoundGround.playing)
			{
				stopSounds();
				walkSoundGround.play();
			}
		}
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
		if (frozen)
			return;
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
		#else
		if ((FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.getAxis(0) > 0.5) || FlxG.keys.pressed.D)
		{
			right = true;
			left = false;
		}
		else if ((FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.getAxis(0) < -0.5) || FlxG.keys.pressed.A)
		{
			left = true;
			right = false;
		}
		else
		{
			left = false;
			right = false;
		}

		if ((FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.getAxis(1) > 0.5) || FlxG.keys.pressed.S)
		{
			down = true;
			up = false;
		}
		else if ((FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.getAxis(1) < -0.5) || FlxG.keys.pressed.W)
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

	private var healthbar:Healthbar;

	public function setHealthbar(_healthbar:Healthbar):Player
	{
		healthbar = _healthbar;
		healthbar.x = this.x;
		healthbar.y = this.y;
		healthbar.followObject(this);
		healthbar.updateHealth(health, 25.0);
		return this;
	}

	private var paralyzed = 0.0;

	public function hitAndParalyze(slime:FlxSprite)
	{
		if (paralyzed > 0)
			return;

		health -= FlxG.random.float(1.0, 5.0);
		if (healthbar != null)
			healthbar.updateHealth(health, 25.0);

		if (health < 0)
		{
			kill();
			return;
		}
		paralyzed = 0.4;
		var _angle = FlxAngle.angleBetween(this, slime, true);
		velocity.set(-speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
	}

	public var frozen = false;

	public function freeze(facing:Int = FlxObject.DOWN)
	{
		frozen = true;
		up = false;
		left = false;
		right = false;
		down = false;
		velocity.set(0, 0);
		animation.play(Std.string(facing));
	}

	override function kill()
	{
		super.kill();
		exists = true;
		color = FlxColor.GRAY >> 1;
		if (parent != null)
			parent.gameOver();
	}

	override function destroy()
	{
		super.destroy();
		stopSounds();
	}

	private var action = false;

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
		}

		if (frozen)
			return;

		var __angle = 0.0;
		if (paralyzed <= 0)
		{
			updateMovement();
			if (up || down || left || right)
			{
				var speed = getFloorSpeed();
				velocity.set(speed, 0);
				updateSoundFromSpeed(speed);

				if ((up && down) || (!up && !down))
				{
					if (left && right)
						velocity.set(0, 0);
					else if (left)
					{
						facing = FlxObject.LEFT;
						__angle = 180;
					}
					else if (right)
					{
						facing = FlxObject.RIGHT;
						__angle = 0;
					}
				}
				else if (up)
				{
					facing = FlxObject.UP;
					if ((left && right) || (!left && !right))
						__angle = 270;
					else if (left)
						__angle = 225;
					else if (right)
						__angle = 315;
				}
				else if (down)
				{
					facing = FlxObject.DOWN;
					if ((left && right) || (!left && !right))
						__angle = 90;
					else if (left)
						__angle = 135;
					else if (right)
						__angle = 45;
				}

				velocity.rotate(FlxPoint.weak(0, 0), __angle);
			}
			else
			{
				velocity.set(0, 0);
				stopSounds();
			}
		}

		var anyAction = FlxG.keys.justPressed.SPACE;
		#if js
		anyAction = anyAction || Main.html5gamepad.getButton(0);
		#end
		if (!action && anyAction)
		{
			action = true;
			if (__angle == 0)
				__angle = FlxAngle.angleFromFacing(facing, true);
			var stone = parent.stones.getFirstAvailable();
			if (stone == null && parent.stones.countLiving() < parent.stones.maxSize)
				parent.stones.add(new Stone(getMidpoint().x - 2, getMidpoint().y - 2, __angle));
			else if (stone != null)
				stone.throwStone(getMidpoint().x - 2, getMidpoint().y - 2, __angle);
		}
		if (!anyAction)
			action = false;

		if (paralyzed <= 0)
			updateAnim();
	}
}
