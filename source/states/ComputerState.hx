package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import theactualgame.TheActualGameSubstate;

class ComputerState extends FlxState
{
	public static final FadeColor = FlxColor.fromRGB(25, 25, 25);

	private var screen:FlxSprite;
	private var startupSound:FlxSound;
	private var clickSound:FlxSound;
	private var casseteLoadingSound:FlxSound;
	private var stopTape:FlxSound;

	private var indicator:Indicator;

	override function create()
	{
		super.create();

		startupSound = new FlxSound().loadEmbedded("assets/sounds/startup.ogg");
		clickSound = new FlxSound().loadEmbedded("assets/sounds/click.ogg");
		casseteLoadingSound = new FlxSound().loadEmbedded("assets/sounds/cassette.ogg", true);
		stopTape = new FlxSound().loadEmbedded("assets/sounds/stoptape.ogg");

		createScreen();

		FlxG.camera.fade(FadeColor, 0.2, true, () ->
		{
			startBootAnimation();
		});

		add(indicator = new Indicator());
	}

	private function startBootAnimation()
	{
		new FlxTimer().start(0.5, (t) ->
		{
			screen.animation.play("title");
			t.start(0.9, (t) ->
			{
				screen.animation.play("memory");
				startupSound.play();
				indicator.showAction();
				waitingForPress = true;
			});
		});
	}

	private function continueBootAnimation()
	{
		waitingForPress = false;
		indicator.hide();
		clickSound.play();
		casseteLoadingSound.play();
		screen.animation.play("tape");
		new FlxTimer().start(2.3, (t) ->
		{
			screen.animation.play("checksum");
			casseteLoadingSound.stop();
			stopTape.play();
			t.start(1.3, (t) ->
			{
				FlxG.camera.fade(FadeColor, 0.15, () ->
				{
					remove(screen);
					openSubState(new TheActualGameSubstate(this));
				});
			});
		});
	}

	private function createScreen()
	{
		screen = new FlxSprite(0, 0).loadGraphic("assets/images/computer/boot.png", true, 64, 64);
		screen.animation.add("off", [0], 5);
		screen.animation.add("title", [1], 5);
		screen.animation.add("memory", [2], 5);
		screen.animation.add("tape", [3], 5);
		screen.animation.add("checksum", [4], 5);
		screen.animation.play("off");
		add(screen);
	}

	private var waitingForPress = false;
	private var pressed = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var anyAction = FlxG.keys.justPressed.ENTER;

		#if js
		anyAction = Main.html5gamepad.getButton(1) || anyAction;
		#end

		if (!pressed)
		{
			if (anyAction && waitingForPress)
			{
				pressed = true;
				continueBootAnimation();
			}
		}
	}
}
