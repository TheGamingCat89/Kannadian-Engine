var PlayState = require("PlayState");
var Conductor = require("Conductor");
var FlxG = require("flixel.FlxG");
var FlxMath = require("flixel.math.FlxMath");

function update(elapsed:Float)
{
    PlayState.SONG.speed = FlxMath.lerp(1.5, 6, Conductor.songPosition / FlxG.sound.music.length);

    return;
}