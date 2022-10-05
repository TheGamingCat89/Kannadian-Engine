package assets.preload.classes;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class CrossFade extends FlxSprite
{
    public function new(character:Character, group:FlxTypedGroup<CrossFade>, ?isDad:Bool = false)
    {
        super();

        frames = character.frames;
		alpha = 0.3;
		setGraphicSize(Std.int(character.width), Std.int(character.height));
		scrollFactor.set(character.scrollFactor.x,character.scrollFactor.y);
		updateHitbox();
		flipX = character.flipX;
		flipY = character.flipY;
		x = character.x + FlxG.random.float(0,60);
		y = character.y + FlxG.random.float(-50, 50);
		offset.x = character.offset.x;
		offset.y = character.offset.y; 
		animation.add('cur', character.animation.curAnim.frames, 24, false);
		animation.play('cur', true);
        animation.curAnim.curFrame = character.animation.curAnim.curFrame;
		switch(character.curCharacter)
		{
			case 'gf-pixel':
				color = 0xFFa5004d;
				antialiasing = false;
			case 'monster' | 'monster-christmas':
				color = 0xFF981b3a;
				antialiasing = FlxG.save.data.antialiasing;
			case 'bf' | 'bf-car' | 'bf-christmas':
				color = 0xFF1b008c;
				antialiasing = FlxG.save.data.antialiasing;
			case 'bf-pixel':
				color = 0xFF00368c;
				antialiasing = false;
			case 'senpai' | 'senpai-angry':
				color = 0xFFffaa6f;
				antialiasing = false;
			case 'spirit':
				alpha = 0;
				kill();
				destroy();
				return;
			case 'sarvente' | 'sarvente-dark' | 'sarvente-lucifer' | 'selever':
				color = 0xFFe32486;
				antialiasing = FlxG.save.data.antialiasing;
			case 'ruv':
				color = 0xFF2e0069;
				antialiasing = FlxG.save.data.antialiasing;
			default:
				color = FlxColor.fromString("#" + character.iconColor);
				antialiasing = FlxG.save.data.antialiasing;
		}
	
		var fuck = FlxG.random.bool(70);
		
		var velo = 12 * 5;
		if (isDad) {
			if (fuck) velocity.x = -velo;
			else velocity.x = velo;
		}
		else {
			if (fuck) velocity.x = velo;
			else velocity.x = -velo;
		}			
	
		FlxTween.tween(this, {alpha: 0}, 0.35, {
			onComplete: function(twn:FlxTween)
			{
				kill();
				destroy();
			}
		});

		group.add(this);
    }
}