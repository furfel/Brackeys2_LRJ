package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.ComputerState;

class TheActualGameSubstate2 extends FlxState
{
	private var player:Player;
	private var follower:Follower;
	private var steps1:FlxSound;

	override function create()
	{
		super.create();

		steps1 = new FlxSound().loadEmbedded("assets/sounds/steps1.ogg", true);
		add(new FlxSprite(0, 0).loadGraphic("assets/images/mmo/forest.png"));

		add(player = new Player(30, 7, null));
		player.freeze();

		add(follower = new Follower(18, 65, null, null, null));
		follower.animation.play(Std.string(FlxObject.UP) + "walk");

		new FlxTimer().start(1.0, (_) ->
		{
			FlxG.camera.fade(ComputerState.FadeColor, 0.7, true, () ->
			{
				steps1.volume = 0;
				steps1.play();
				steps1.fadeIn(0.5);
				new FlxTimer().start(1.0, (tm) ->
				{
					FlxTween.linearMotion(follower, follower.x, follower.y, 30, 15, 2.5, {
						onComplete: (tw) ->
						{
							steps1.stop();
							follower.animation.play(Std.string(FlxObject.UP));

							tm.start(0.8, (tm2) ->
							{
								FlxG.sound.play("assets/sounds/hooray.ogg", () ->
								{
									tm2.start(0.8, (tm3) ->
									{
										steps1.volume = 1;
										steps1.play();
										player.animation.play("walk" + Std.string(FlxObject.UP));
										follower.animation.play(Std.string(FlxObject.UP) + "walk");
										FlxTween.linearMotion(follower, follower.x, follower.y, 36, -12, 1.3);
										FlxTween.linearMotion(player, player.x, player.y, 36, -12, 1.3, {
											onComplete: (tw2) ->
											{
												steps1.stop();
												FlxG.camera.fade();
											}
										});
										steps1.fadeOut(1.3);
									});
								});
							});
						}
					});
				});
			}, true);
		});
	}
}
