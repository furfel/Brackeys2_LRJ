package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import objects.cassette.Cassette;

class CasetteState extends FlxSubState
{
	public static final MAX_CLICKS = 15;

	private var cassette:Cassette;
	private var arrow:FlxSprite;

	private var swipe = new Array<FlxSound>();

	override public function create()
	{
		super.create();
		add(cassette = new Cassette(0, 0));
		add(arrow = new FlxSprite(10, 20).loadGraphic("assets/images/cassette/arrow.png"));
		arrow.alpha = 0.85;

		swipe.push(new FlxSound().loadEmbedded("assets/sounds/swipe1.ogg", false, false));
		swipe.push(new FlxSound().loadEmbedded("assets/sounds/swipe2.ogg", false, false));
	}

	private var next:Int = 0;

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

		if (next == 0)
		{
			if (right && !down && !up && !left)
				pressedNext();
		}
		else if (next == 1)
		{
			if (down && !up && !left && !right)
				pressedNext();
		}
		else if (next == 2)
		{
			if (left && !up && !right && !down)
				pressedNext();
		}
		else if (next == 3)
		{
			if (up && !down && !right && !left)
				pressedNext();
		}
	}

	private var clicks = 0;

	private function pressedNext()
	{
		if (cassette == null)
			return;
		swipe[next % 2].play(true);
		next = (next + 1) % 4;
		clicks++;
		cassette.move(clicks, MAX_CLICKS);
		updateArrow();

		if (clicks >= MAX_CLICKS)
		{
			if ((_parentState != null) && (_parentState is DeskState))
			{
				cast(_parentState, DeskState).cassetteDone = true;
				cast(_parentState, DeskState).cassette.angle = 30;
				close();
			}
		}
	}

	private function updateArrow()
	{
		arrow.angle = next * 90;
	}
}
