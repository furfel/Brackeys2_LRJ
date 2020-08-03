package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.desk.Cassette;
import objects.desk.Computer;
import objects.desk.IFocusable;
import objects.desk.Pointer;
import objects.desk.Tape;

class DeskState extends FlxState
{
	public var cassette:Cassette;
	public var tape:Tape;

	private var computer:Computer;

	private var pointer:Pointer;

	private var focusables = new Array<IFocusable>();
	private var current:Int = 0;

	override function create()
	{
		super.create();

		add(new FlxSprite(0, 0).loadGraphic("assets/images/backgrounddesk.png"));
		add(cassette = new Cassette(43, 45));
		add(computer = new Computer(0, 0));
		add(tape = new Tape(12, 35));

		focusables.push(cassette);
		focusables.push(tape);
		focusables.push(computer);

		add(pointer = new Pointer(0, 0));
		move();
	}

	private function move(back:Bool = false)
	{
		focusables[current].unfocus();

		if (back)
			current--;
		else
			current++;
		current = current < 0 ? current = focusables.length - 1 : current % focusables.length;

		focusables[current].focus();

		pointer.setPosition(focusables[current].getPoint().x, focusables[current].getPoint().y);
	}

	public var cassetteDone = false;
	public var tapeDone = true;

	private function doAction()
	{
		focusables[current].doAction(this);
	}

	public function zoomToComputer()
	{
		FlxTween.tween(FlxG.camera, {
			"scroll.x": 14,
			"scroll.y": -8,
			zoom: 2.3
		}, 0.6, {
			ease: FlxEase.backIn,
			onComplete: (tw) ->
			{
				FlxG.camera.fade(ComputerState.FadeColor, 0.3, () ->
				{
					FlxG.switchState(new ComputerState());
				});
			}
		});
	}

	private var left = false;
	private var right = false;
	private var action = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var anyL = FlxG.keys.justPressed.A;
		var anyR = FlxG.keys.justPressed.D;
		var anyAction = FlxG.keys.justPressed.ENTER;

		#if js
		anyL = anyL || Main.html5gamepad.getAxis(0) < -0.5;
		anyR = anyR || Main.html5gamepad.getAxis(0) > 0.5;
		anyAction = anyAction || Main.html5gamepad.getButton(1);
		#end

		if (!left && anyL)
		{
			left = true;
			move(true);
		}
		else if (!right && anyR)
		{
			right = true;
			move();
		}
		else if (!action && anyAction)
		{
			action = true;
			doAction();
		}

		if (!anyL)
			left = false;
		if (!anyR)
			right = false;
		if (!anyAction)
			action = false;
	}
}
