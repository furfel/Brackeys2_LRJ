package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.Player;

class RoomState2 extends FlxState
{
	private var room:FlxSprite;
	private var phone:FlxSprite;
	private var blocks = new FlxTypedGroup<FlxObject>();
	private var player:Player;

	private var desk:FlxObject;

	private var dialogue:FlxSound;

	private var indicator:Indicator;

	override function create()
	{
		super.create();
		dialogue = new FlxSound().loadEmbedded("assets/sounds/monologue.ogg", false, true);

		add(room = new FlxSprite(0, 0).loadGraphic("assets/images/room/room.png"));
		createBlocks();
		add(player = new Player(20, 16, FlxObject.UP));
		FlxG.worldBounds.set(0, 0, 64, 64);

		player.freeze();
		FlxG.camera.fade(FlxColor.BLACK, 1, true, () ->
		{
			dialogue.onComplete = () ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, () ->
				{
					FlxG.switchState(new RoomState());
				});
			};
			dialogue.play();
		});
		FlxG.camera.alpha = 1;
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, blocks);
	}
}
