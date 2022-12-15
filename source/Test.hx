package;

import FlxWindow.FlxTransWindow;
import flixel.FlxState;
import flixel.FlxSprite;

class Test extends FlxState
{
    override function create() {
        super.create();
        var logo = new FlxSprite().loadGraphic(Paths.image("logo"));
        logo.screenCenter();
        add(logo);
        
        FlxTransWindow.getWindowsTransparent();

    }
}