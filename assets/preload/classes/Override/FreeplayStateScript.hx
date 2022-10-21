/*import openfl.events.KeyboardEvent;
import flixel.util.FlxTimer;
import flixel.FlxG;
import openfl.ui.Keyboard;
import FreeplayState;
import PlayState;
import LoadingState;

function changeSelection(change)
{
    if (FreeplayState.isWeek && FreeplayState.weeks[FreeplayState.curWeekSelected].weekName.toLowerCase() == "tutorial")
    {
        FreeplayState.instance.scoreBG.visible = true;
		FreeplayState.instance.scoreText.visible = true;
		FreeplayState.instance.diffText.visible = true;
		FreeplayState.instance.authorTxt.visible = true;
		FreeplayState.instance.infoText.visible = true;
		#if PRELOAD_ALL
		FreeplayState.instance.text.visible = true;
		FreeplayState.instance.textBG.visible = true;
		#end   
    }
}

function keyDown(event:KeyboardEvent) //types are ignored but they might help code readablity
{
    if (FreeplayState.isWeek && FreeplayState.weeks[FreeplayState.curWeekSelected].weekName.toLowerCase() == "tutorial")
    {
        switch (event.keyCode)
        {
            case Keyboard.LEFT | Keyboard.RIGHT | Keyboard.ESCAPE | Keyboard.ENTER:
                FreeplayState.isWeek = false;    
        }

        if (event.keyCode == Keyboard.ENTER)
        {
            var poop = Highscore.formatSong("tutorial", FreeplayState.curDifficulty);
        
            PlayState.SONG = Song.loadFromJson(poop, "tutorial");
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = FreeplayState.curDifficulty;
            PlayState.storyWeek = FreeplayState.weeks[curWeekSelected].week;
            trace('CUR WEEK ' + PlayState.storyWeek);
            LoadingState.loadAndSwitchState(new PlayState());    
        } 
    }
}*/