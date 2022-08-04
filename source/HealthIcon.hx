package;

#if sys
import sys.FileSystem;
#end
import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var isOldIcon:Bool = false;
	var isPlayer:Bool = false;

	public var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		isOldIcon = false;
		this.isPlayer = isPlayer;

        changeIcon(char);
		this.char = char;
       	antialiasing = OptionsMenu.options.antialiasing;
        scrollFactor.set();
	}

	public function swapOldIcon()
	{
		if (isOldIcon) changeIcon("bf");
		else changeIcon("bf-old");
	}

	public function changeIcon(character:String) {
		if (character != "bf-pixel" && character != "bf-old")
			character = character.split("-")[0].trim();

		if (character.endsWith("-pixel"))
			antialiasing = false;

		if (char != character)
		{
			if (animation.getByName(character) == null)
			{
		#if sys if (FileSystem.exists(Paths.image("icons/icon-" + character))) #end
					loadGraphic(Paths.image("icons/icon-" + character), true, 150, 150);
		#if sys else 
					loadGraphic(Paths.image("icons/icon-face"), true, 150, 150); #end
				animation.add(character, [0, 1], 0, false, isPlayer);
			}
			animation.play(character);
			char = character;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
