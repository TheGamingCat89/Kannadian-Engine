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

/**
    will work as menu and as data saver or some shit
**/
class KeyBinds extends MusicBeatSubstate
{
    var grpKeybinds:FlxTypedGroup<Alphabet>;
    var grpCurKeys:FlxTypedGroup<Alphabet>;
    var curSelected:Int;
    
    var text:FlxText;
    static public var keybinds:Map<String, Array<FlxKey>>;
    var e:Array<FlxKey> = [27, 20, 13, 18, 8];

    override function create() {

        loadKeybinds();

        var bg = new FlxSprite(0,0).loadGraphic(Paths.image("menuBGBlue"));
        bg.scrollFactor.set();
        add(bg);

        grpKeybinds = new FlxTypedGroup<Alphabet>();
        add(grpKeybinds);

        grpCurKeys = new FlxTypedGroup<Alphabet>();
        add(grpCurKeys);

        var i = 0; // no count variable waa
        for (key => value in keybinds)
        {
            var thing = new Alphabet(0,0, key + " keybind: " + value, true);
            thing.isMenuItem = true;
            thing.targetY = i;
            grpKeybinds.add(thing);

            var currentKey = new Alphabet(thing.x + thing.widthOfWords + 50, thing.y, value[0].toString(), true);
            grpCurKeys.add(currentKey);
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
            close();

        if(FlxG.keys.justReleased.ENTER)
        {         
            new FlxTimer().start(1, timer -> 
            {
                text.visible = true;
                settingKeybind = true;
            });
        }

        if(settingKeybind && FlxG.keys.justPressed.ANY && !FlxG.keys.anyJustPressed(e))
        {
            trace(grpKeybinds.members[curSelected].text.split(" ")[0] + ": " + keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0]);
            keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0] = FlxG.keys.firstJustPressed();
            trace(grpKeybinds.members[curSelected].text.split(" ")[0] + ": " + keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0]);

            //IHATE THAT I HAVE TO DO THIS IM SORRY
            switch (grpKeybinds.members[curSelected].text.split(" ")[0])
            {
                //PLEASE WORK
                case "left":
                    FlxG.save.data.leftBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();//should be a string number
                case "down":
                    FlxG.save.data.downBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
                case "up":
                    FlxG.save.data.upBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
                case "right":
                    FlxG.save.data.rightBind = keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
            }
            grpKeybinds.members[curSelected].text += keybinds[grpKeybinds.members[curSelected].text.split(" ")[0]][0].toString();
            FlxG.save.flush();
            text.visible = false;
            settingKeybind = false;
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;
        //no sound fuck you
        if (curSelected > 3)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = 3;

        var bullShit:Int = 0;
        grpKeybinds.forEach((key) -> { //ilike this more than function(sth:blah)
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