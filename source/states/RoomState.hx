package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import objects.Player;

class RoomState extends FlxState
{
	private var room:FlxSprite;
	private var phone:FlxSprite;
	private var blocks = new FlxTypedGroup<FlxObject>();
	private var player:Player;

	private var ringtone:FlxSound;
	private var phoneButton:FlxSound;
	private var dialogue:FlxSound;

	override function create()
	{
		super.create();

		ringtone = new FlxSound().loadEmbedded("assets/sounds/nokiatune.ogg", true);
		phoneButton = new FlxSound().loadEmbedded("assets/sounds/button.ogg");
		dialogue = new FlxSound().loadEmbedded("assets/sounds/dialogue.ogg", false, true);

		add(room = new FlxSprite(0, 0).loadGraphic("assets/images/room/room.png"));
		createPhone();
		createBlocks();
		add(player = new Player(28, 26));
		FlxG.worldBounds.set(0, 0, 64, 64);

		ringtone.play();
	}

	private function createPhone()
	{
		phone = new FlxSprite(5, 2).loadGraphic("assets/images/room/phone.png", true, 18, 18);
		phone.animation.add("ringing", [0, 0, 1, 1], 3);
		phone.animation.play("ringing");
		add(phone);
	}

	private function answerCall()
	{
		phone.kill();
		ringtone.stop();
		player.freeze();
		dialogue.onComplete = () ->
		{
			phone.kill();
			phoneButton.play();
			player.unfreeze();
		};
		phoneButton.onComplete = () ->
		{
			phoneButton.onComplete = () -> {};
			dialogue.play();
		};
		phoneButton.play();
	}

	private function createBlocks()
	{
		// Walls
		blocks.add(new FlxObject(0, 0, 64, 8));
		blocks.add(new FlxObject(0, 0, 2, 64));
		blocks.add(new FlxObject(62, 0, 2, 64));
		blocks.add(new FlxObject(0, 62, 64, 2));

		blocks.add(new FlxObject(8, 0, 24, 13)); // Desk
		blocks.add(new FlxObject(47, 20, 62 - 47, 47 - 20)); // Bed

		blocks.forEach((o) -> o.solid = o.immovable = true);
		add(blocks);
	}

	var action = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, blocks);

		var anyAction = FlxG.keys.justPressed.ENTER;
		#if js
		anyAction = anyAction || Main.html5gamepad.getButton(1);
		#end

		if (!action && anyAction)
		{
			if (player.overlaps(phone) && phone.alive)
			{
				answerCall();
			}
			action = true;
		}

		if (!anyAction)
			action = false;
	}
}
