package states;

import flixel.FlxG;
import flixel.FlxState;
import haxe.iterators.ArrayIterator;
import objects.desk.Cassette;
import objects.desk.Computer;
import objects.desk.IFocusable;
import objects.desk.Pointer;
import objects.desk.Tape;

class DeskState extends FlxState
{
	private var cassette:Cassette;
	private var tape:Tape;
	private var computer:Computer;

	private var pointer:Pointer;

	private var focusables = new Array<IFocusable>();
	private var current:Int = 0;

	override function create()
	{
		super.create();

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

	private var left = false;
	private var right = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var anyL = FlxG.keys.justPressed.A;
		var anyR = FlxG.keys.justPressed.D;

		#if js
		anyL = anyL || Main.html5gamepad.getAxis(0) < -0.5;
		anyR = anyR || Main.html5gamepad.getAxis(0) > 0.5;
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

		if (!anyL)
			left = false;
		if (!anyR)
			right = false;
	}
}
