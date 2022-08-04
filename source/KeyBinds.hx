package;

import Controls.Control;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.input.FlxBaseKeyList;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;

//!also improve menu because it sucks
/**
    will work as menu and as data saver or some shit
**/
class KeyBinds extends MusicBeatSubstate
{
    var grpKeybinds:FlxTypedGroup<Alphabet>;//direction keybind text
    var curSelected:Int;
    
    var text:FlxText;
    static public var keybinds:Map<String, Array<FlxKey>>;
    var e:Array<FlxKey> = [27, 20, 13, 18, 8];
    var lastPressed:FlxKey = -1;

    override function create() {

        loadKeybinds();

        var bg = new FlxSprite(0,0).loadGraphic(Paths.image("menuBGBlue"));
        bg.scrollFactor.set();
        add(bg);

        grpKeybinds = new FlxTypedGroup<Alphabet>();
        add(grpKeybinds);

        var i = 0; // no count variable waa
        for (key => value in keybinds)
        {
            var thing = new Alphabet(0,0, key + " keybind - " + value[0].toString(), true);
            thing.isMenuItem = true;
            thing.targetY = i;
            grpKeybinds.add(thing);

            i++;
        }

        text = new FlxText(FlxG.width/2, 100, 0, "PRESS ANY KEY", 32);
        text.visible = false;
        add(text);

        super.create();
    }

    public function new() {
        super();      
    }
    
    var settingKeybind = false;

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            if (settingKeybind)
                settingKeybind = text.visible = false;
            else
                close();
        }

        if(FlxG.keys.justPressed.ENTER)
            text.visible = settingKeybind = true;

        if(settingKeybind && FlxG.keys.justPressed.ANY && !FlxG.keys.anyJustPressed(e))
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));

            trace(grpKeybinds.members[curSelected].text.split(" ")[0] + ": " + keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0]);
            keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0] = FlxG.keys.firstJustPressed();
            lastPressed = -1;
            trace(grpKeybinds.members[curSelected].text.split(" ")[0] + ": " + keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0]);

            //IHATE THAT I HAVE TO DO THIS IM SORRY
            switch (grpKeybinds.members[curSelected].text.split(" ")[0])
            {
                //PLEASE WORK
                case "left":
                    FlxG.save.data.leftBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
                case "down":
                    FlxG.save.data.downBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
                case "up":
                    FlxG.save.data.upBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
                case "right":
                    FlxG.save.data.rightBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
            }
            grpKeybinds.members[curSelected].changeText(grpKeybinds.members[curSelected].text.split(" ")[0] + " keybind - " + keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString());
            FlxG.save.flush();
            settingKeybind = text.visible = false;
        }
    }

    function changeSelection(change:Int = 0)
    {
        //sound fuck you
        FlxG.sound.play(Paths.sound('scrollMenu'));

        curSelected += change;

        if (curSelected > 3)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 3;

        var bullShit:Int = 0;
        grpKeybinds.forEach(key -> { //ilike this more than function(sth:blah)
            key.targetY = bullShit - curSelected;
			bullShit++;

            key.alpha = 0.6;
            if (key.targetY == 0)
                key.alpha = 1;
        });
    }

    public static function loadKeybinds()
    {
        keybinds = [
            "left" =>   [FlxKey.fromString(FlxG.save.data.leftBind), LEFT],
            "down" =>   [FlxKey.fromString(FlxG.save.data.downBind), DOWN],
            "up" =>     [FlxKey.fromString(FlxG.save.data.upBind), UP],
            "right" =>  [FlxKey.fromString(FlxG.save.data.rightBind), RIGHT]
        ];
    }
}