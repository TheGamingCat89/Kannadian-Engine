package;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class GameplayChangers extends MusicBeatSubstate
{

    public static var changers:Map<String, Dynamic> = [
        "Bot Play" => false,
        "Opponent Play" => false,
        "Speed Multiplier" => 1.0
    ];
    var changersLength:Int = 0;
    private var grpChangers:FlxTypedGroup<Alphabet>;
    private var curSelected:Int = 0;
    override function create() {
        
        var bg = new FlxSprite(0,0).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
        bg.scrollFactor.set();
        bg.alpha = 0.6;
        add(bg);

        grpChangers = new FlxTypedGroup<Alphabet>();
        add(grpChangers);

        var i = 0;
        for (key => value in changers)
        {
            var item = new Alphabet(0,0, key + (value is Bool ? (value ? " - ON" : " - OFF") : " - " + value), true);
            item.isMenuItem = true;
            item.targetY = i;
            grpChangers.add(item);
            changersLength++;
            i++;
        }

        super.create();
    }

    override function keyDown(event:KeyboardEvent) {
        if (event.keyCode == Keyboard.DOWN)
            changeSelection(1);
        if (event.keyCode == Keyboard.UP)
            changeSelection(-1);

        if (event.keyCode == Keyboard.ESCAPE)
        {
            FreeplayState.isInGameChanger = false;
            close();
        }

        var curSelectedChanger = changers[grpChangers.members[curSelected].text.split("-")[0].trim()];
        if (curSelectedChanger == null) return;

        if (event.keyCode == Keyboard.ENTER)
        {    
            if (!(curSelectedChanger is Bool)) return;

            changers[grpChangers.members[curSelected].text.split("-")[0].trim()] = !curSelectedChanger;
            grpChangers.members[curSelected].changeText(grpChangers.members[curSelected].text.split("-")[0].trim() + (changers[grpChangers.members[curSelected].text.split("-")[0].trim()] ? " - ON" : " - OFF"));
        }   

        if (event.keyCode == Keyboard.LEFT)
        {
            /*if (curSelectedChanger is Int)
                changers[grpChangers.members[curSelected].text.split("-")[0].trim()]++;
     else*/ if (curSelectedChanger is Float)
                changers[grpChangers.members[curSelected].text.split("-")[0].trim()] -= 0.1;
            else return;

            grpChangers.members[curSelected].changeText(grpChangers.members[curSelected].text.split("-")[0].trim() + " - " + changers[grpChangers.members[curSelected].text.split("-")[0].trim()]);
        }

        if (event.keyCode == Keyboard.RIGHT)
        {
            /*if (changers[grpChangers.members[curSelected].text.split("-")[0].trim()] is Int)
                changers[grpChangers.members[curSelected].text.split("-")[0].trim()]++;
     else*/ if (changers[grpChangers.members[curSelected].text.split("-")[0].trim()] is Float)
                changers[grpChangers.members[curSelected].text.split("-")[0].trim()] += 0.1;
            else return;

            //if
    
            grpChangers.members[curSelected].changeText(grpChangers.members[curSelected].text.split("-")[0].trim() + " - " + changers[grpChangers.members[curSelected].text.split("-")[0].trim()]);
        }

        super.keyDown(event);
    }

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
        if(curSelected > changersLength - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = changersLength - 1;

        var bullShit:Int = 0;
        grpChangers.forEach(item -> {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = (item.targetY == 0 ? 1 : 0.6);
        });
    }
}