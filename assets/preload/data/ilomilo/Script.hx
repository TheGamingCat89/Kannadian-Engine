var FlxEase = require("flixel.tweens.FlxEase");
var FlxTween = require("flixel.tweens.FlxTween");
var PlayState = require("PlayState");
var OptionsMenu = require("OptionsMenu");

var originalPos = 0.0;

function create()
{
    OptionsMenu.options.downScroll = false;
}

function createPost()
{
    originalPos = PlayState.instance.iconP1.y;

    firstTween();
}

function firstTween()
{
    //bounce
    //by EyeDaleHim 
    //edited by me (barely)
    FlxTween.tween(PlayState.instance.iconP1, {y: PlayState.instance.iconP1.y - 100, angle: -15}, (60 / PlayState.SONG.bpm) / 2, {
        ease: FlxEase.circOut,
        onComplete: (twn) ->
        {
            FlxTween.tween(PlayState.instance.iconP1, {y: originalPos, angle: 15}, (60 / PlayState.SONG.bpm) / 2, {
                ease: FlxEase.circIn,
                onComplete: function(twn)
                {
                    PlayState.instance.iconP1.flipX = !PlayState.instance.iconP1.flipX;
                    firstTween();
                }
            });
        }
    });
}