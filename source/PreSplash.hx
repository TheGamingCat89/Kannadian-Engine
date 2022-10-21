package;

import Discord.DiscordClient;
import sys.thread.Thread;
import flixel.FlxG;
import flixel.FlxState;

class PreSplash extends FlxState
{
    override public function create()
    {
        //i love doing stupid shit
        Thread.create(() -> {   
            FlxG.sound.cache("flixel/sounds/flixel");
            FlxG.save.bind('kannada', 'TheGamingCat86');
    
		    Highscore.load();
		    PlayerSettings.init();
            
		    OptionsData.init();
		    OptionsMenu.loadSettings();
            KeyBinds.loadKeybinds();
            
            if (FlxG.save.data.volume != null)
		    	FlxG.sound.volume = Std.parseFloat(FlxG.save.data.volume);
        
	        FlxG.mouse.visible = false;
		    FlxG.worldBounds.set(0,0);
		    FlxG.game.focusLostFramerate = 60;
		    FlxG.autoPause = false;
    
		    #if cpp
		    DiscordClient.initialize();
		    #end

            FlxG.switchState(new FlxSplashCustom());  
        });  
    }
}