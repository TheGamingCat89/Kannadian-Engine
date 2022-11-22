var PlayState = require("PlayState");
var Std = require("Std");
var FlxSprite = require("flixel.FlxSprite");
var FlxG = require("flixel.FlxG");
var FlxTween = require("flixel.tweens.FlxTween");

function create()
{
    trace("loaded script");
}
   
function opponentNoteHit(daNote)
{
    var dad = PlayState.instance.dad; //gr
    var crossFade = new FlxSprite();
    crossFade.frames = dad.frames;
    crossFade.alpha = 0.3;
    crossFade.setGraphicSize(Std.int(dad.width), Std.int(dad.height));
    crossFade.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
    crossFade.updateHitbox();
    crossFade.flipX = dad.flipX;
    crossFade.flipY = dad.flipY;
    crossFade.x = dad.x;
    crossFade.y = dad.y;
    crossFade.offset.x = dad.offset.x;
    crossFade.offset.y = dad.offset.y;
    crossFade.animation.add("cur", dad.animation.curAnim.frames, 24, false);
    crossFade.animation.play("cur", true);
    crossFade.animation.curAnim.curFrame = dad.animation.curAnim.curFrame;
    crossFade.color = 0xFF8103CA;
    var fuck = FlxG.random.bool(70);

	if (fuck) crossFade.velocity.x = -12 * 5;
	else crossFade.velocity.x =  12 * 5;	

	FlxTween.tween(crossFade, {alpha: 0}, 0.35, {
		onComplete: function(twn)
		{
            PlayState.instance.remove(crossFade);
			crossFade.kill();
			crossFade.destroy(); 
		}
	});

	PlayState.instance.insert(PlayState.instance.members.indexOf(PlayState.instance.dad) - 1, crossFade);
}