package objects.desk;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import states.DeskState;

class Computer extends FlxTypedSpriteGroup<FocusableSprite> implements IFocusable
{
	public var monitor:FocusableSprite = cast(new FocusableSprite(32, 11).loadGraphic("assets/images/desk/monitor.png"));

	private var keyboard:FocusableSprite = cast(new FocusableSprite(1, 26).loadGraphic("assets/images/desk/keyboard.png"));

	private var focusPoint = new FlxPoint(0, 0);

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		add(monitor);
		add(keyboard);
		focusPoint.set(monitor.x + monitor.width / 2, monitor.y + monitor.height / 2);
	}

	public function focus():Any
	{
		forEach((sprite) -> sprite.focus());
		return null;
	}

	public function unfocus():Any
	{
		forEach((sprite) -> sprite.unfocus());
		return null;
	}

	public function getPoint():FlxPoint
	{
		return focusPoint;
	}

	public function doAction(parentState:FlxState):Void
	{
		if ((parentState is DeskState))
		{
			var state = cast(parentState, DeskState);
			if (state.tapeDone)
			{
				state.zoomToComputer();
			}
		}
	}
}
