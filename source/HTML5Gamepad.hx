package;

import js.Browser;
import js.html.Console;
import js.html.Gamepad;
import js.html.GamepadEvent;

class HTML5Gamepad
{
	private var _gamepads:Map<Int, Gamepad> = new Map<Int, Gamepad>();

	public function new()
	{
		#if js
		Browser.window.addEventListener("gamepadconnected", (e) ->
		{
			var event = cast(e, GamepadEvent);
			var gamepad = event.gamepad;
			_gamepads.set(gamepad.index, gamepad);
			Console.log("Gamepad " + gamepad.id + " connected at " + gamepad.index);
		});

		Browser.window.addEventListener("gamepaddisconnected", (e) ->
		{
			var event = cast(e, GamepadEvent);
			var index = event.gamepad.index;
			_gamepads.remove(index);
		});
		#end
	}

	public function getButton(button:Int, index:Int = 0):Bool
	{
		return _gamepads.exists(index) && _gamepads[index].buttons != null && _gamepads[index].buttons[button].pressed;
	}

	public function getAxis(axes:Int, index:Int = 0):Float
	{
		return !_gamepads.exists(index) ? 0.0 : _gamepads[index].axes[axes];
	}

	public function isGamepadConnected(?index:Int):Bool
	{
		return index == null ? _gamepads.keys().hasNext() : _gamepads.exists(index);
	}
}
