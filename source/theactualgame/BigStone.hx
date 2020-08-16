package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class BigStone extends FlxSprite
{
	private var startX = 0.0;
	private var startY = 0.0;
	private var endX = 0.0;
	private var endY = 0.0;

	public function new(X:Float, Y:Float, endX:Float, endY:Float, state:TheActualGameSubstate)
	{
		super(X, Y);

		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		animation.add("", [22], 3);
		animation.play("");

		if (endX > X || endY > Y)
			angularVelocity = 180;
		else
			angularVelocity = -180;

		if (endX > X)
			facing = FlxObject.RIGHT;
		else if (endX < X)
			facing = FlxObject.LEFT;
		else if (endY > Y)
			facing = FlxObject.DOWN;
		else if (endY < Y)
			facing = FlxObject.UP;

		setVelocity();

		this.startX = X;
		this.startY = Y;
		this.endX = endX;
		this.endY = endY;

		createDecors(state);
	}

	private function createDecors(state:TheActualGameSubstate)
	{
		var startHole = new FlxSprite(Std.int(startX / 8) * 8, Std.int(startY / 8) * 8).loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		var endHole = new FlxSprite(Std.int(endX / 8) * 8, Std.int(endY / 8) * 8).loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		startHole.animation.add("", [23], 3);
		startHole.animation.play("");
		endHole.animation.add("", [23], 3);
		endHole.animation.play("");

		switch (facing)
		{
			case FlxObject.LEFT:
				endHole.angle = 180;
			case FlxObject.RIGHT:
				startHole.angle = 180;
			case FlxObject.UP:
				startHole.angle = 90;
				endHole.angle = 270;
			case FlxObject.DOWN:
				startHole.angle = 270;
				endHole.angle = 90;
		}

		setSize(6, 6);
		offset.set(1, 1);

		solid = true;
		immovable = true;

		state.bigStoneDecor.add(startHole);
		state.bigStoneDecor.add(endHole);
	}

	private var timer:FlxTimer;

	override function reset(X:Float, Y:Float)
	{
		super.reset(startX, startY);
		velocity.set(0, 0);
		timer = new FlxTimer().start(FlxG.random.float(2.1, 3.5), (t) ->
		{
			setVelocity();
		});
	}

	override function destroy()
	{
		super.destroy();
		timer.cancel();
		timer.destroy();
	}

	private function setVelocity()
	{
		switch (facing)
		{
			case FlxObject.UP:
				velocity.set(0, -70);
			case FlxObject.DOWN:
				velocity.set(0, 70);
			case FlxObject.RIGHT:
				velocity.set(70, 0);
			case FlxObject.LEFT:
				velocity.set(-70, 0);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		switch (facing)
		{
			case FlxObject.UP:
				if (y <= endY)
					reset(0, 0);
			case FlxObject.DOWN:
				if (y >= endY)
					reset(0, 0);
			case FlxObject.RIGHT:
				if (x >= endX)
					reset(0, 0);
			case FlxObject.LEFT:
				if (x <= endX)
					reset(0, 0);
		}
	}
}
