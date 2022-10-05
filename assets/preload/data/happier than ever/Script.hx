import PlayState;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import Conductor;
import flixel.FlxG;
import Std;
import assets.preload.classes.CrossFade;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import haxe.Json;
import openfl.Assets;
import Paths;
import sys.FileSystem;

var grpCrossFade;

function createPost()
{
    trace(CrossFade);
    trace(PlayState.instance.hscript.interpreter.variables.get("FlxTypedGroup"));
	grpCrossFade = new FlxTypedGroup<CrossFade>();
	trace("ummmm script loaded");
    PlayState.instance.insert(PlayState.instance.members.indexOf(PlayState.instance.dad) - 1, grpCrossFade);    
}
function update(elapsed)
{
    PlayState.SONG.speed = FlxMath.lerp(1.5, 6, Conductor.songPosition / FlxG.sound.music.length);
}

function goodNoteHit(note)
{
    new CrossFade(PlayState.instance.boyfriend, grpCrossFade, true);  
}

function opponentNoteHit(daNote)
{
	new CrossFade(PlayState.instance.dad, grpCrossFade);  
}