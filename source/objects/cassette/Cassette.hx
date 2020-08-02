package objects.cassette;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.system.FlxSound;

class Cassette extends FlxTypedSpriteGroup<FlxSprite>
{
	private var cassette:FlxSprite;
	private var progress:Progress;
	private var pencil_top:PencilTop;
	private var pencil_bottom:PencilBottom;
	private var circle:Circle;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		add(pencil_bottom = new PencilBottom(36, 26));
		add(progress = new Progress(48, 21));
		add(cassette = new FlxSprite(19, 7).loadGraphic("assets/images/cassette/cassette.png"));
		add(circle = new Circle(34, 20));
		add(pencil_top = new PencilTop(36, 4));
	}

	public function move(clicks:Int, max_clicks:Int)
	{
		var frame = Std.string(clicks % 2);
		pencil_bottom.animation.play(frame);
		pencil_top.animation.play(frame);
		circle.animation.play(frame);

		var progressClicks = (clicks * 1.0) / (max_clicks * 1.0);
		progress.setProgress(progressClicks);
	}
}
