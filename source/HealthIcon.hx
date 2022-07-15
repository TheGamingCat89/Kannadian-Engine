package;

import sys.FileSystem;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false, isPixel:Bool = false)
	{
		super();

		//IM SO FUCKING STUPID ill change this later 
		if (FileSystem.exists(Paths.image('icons/icon-' + char + (char == "senpai" || char == "senpai-angry" || char == "spirit" ? '-pixel' : ""))))
			loadGraphic(Paths.image('icons/icon-' + char + (char == "senpai" || char == "senpai-angry" || char == "spirit" ? '-pixel' : "")), true, 150, 150);
		else
			loadGraphic(Paths.image('icons/icon-face'), true, 150, 150);

		if (char == "senpai" || char == "senpai-angry" || char == "spirit")
			antialiasing = true;
		else
			antialiasing = OptionsMenu.options.antialiasing;

		animation.add(char, [0, 1], 0, false, isPlayer);
		
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
