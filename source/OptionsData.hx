package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

class OptionsData
{
    public static function init()
    {    
        if (FlxG.save.data.volume == null)
            FlxG.save.data.volume = FlxG.sound.volume;

        if (FlxG.save.data.ghostTapping == null)
            FlxG.save.data.ghostTapping = false;
        if (FlxG.save.data.downScroll == null)
            FlxG.save.data.downScroll = false;
        if (FlxG.save.data.middleScroll == null)
            FlxG.save.data.middleScroll = false;
        if (FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = false;
        if (FlxG.save.data.resetButton == null)
            FlxG.save.data.resetButton = false;
        if (FlxG.save.data.antialiasing == null)
            FlxG.save.data.antialiasing = false;
        if (FlxG.save.data.flashing == null)
            FlxG.save.data.flashing = false;
        if (FlxG.save.data.cameraZoom == null)
            FlxG.save.data.cameraZoom = false;
        if (FlxG.save.data.simpleAccuracy == null)
            FlxG.save.data.simpleAccuracy = true;

        if (FlxG.save.data.upBind == null)
            FlxG.save.data.upBind =  W.toString();
        if (FlxG.save.data.downBind == null)
            FlxG.save.data.downBind = S.toString();
        if (FlxG.save.data.leftBind == null)
            FlxG.save.data.leftBind = A.toString();
        if (FlxG.save.data.rightBind == null)
            FlxG.save.data.rightBind = D.toString();

        FlxG.save.flush();
    }

    public static function resetData()
    {
        FlxG.save.data.volume = null;
        FlxG.save.data.ghostTapping = null;
        FlxG.save.data.downScroll = null;
        FlxG.save.data.middleScroll = null;
        FlxG.save.data.songPosition = null;
        FlxG.save.data.resetButton = null;
        FlxG.save.data.antialiasing = null;
        FlxG.save.data.flashing = null;
        FlxG.save.data.cameraZoom = null;
        FlxG.save.data.simpleAccuracy = null;
        FlxG.save.data.upBind = null;
        FlxG.save.data.downBind = null;
        FlxG.save.data.leftBind = null;
        FlxG.save.data.rightBind = null;

        FlxG.save.flush();
    }
}