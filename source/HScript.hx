package;

//i forgot i was doing this LOL
//ill work on it.. later
import haxe.Exception;
import openfl.ui.Keyboard;
import lime.app.Application;
import lime.system.System;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
#if cpp
import cpp.Lib;
#end
import flixel.tweens.FlxEase;
#if desktop
import Discord.DiscordClient;
#end
import flixel.math.FlxMath;
import openfl.Assets;
#if sys
import sys.FileSystem;
#end
import hscript.Interp;
import hscript.Parser;

using StringTools;

class HScript 
{
    public var interpreter:Interp;
    public var variables:Map<String, Dynamic>;
    public var parser:Parser;
    static private var hadError:Bool = false;

    //hope this works
    public function new(path:String)
    {
        var file:String = 'trace("No script found");';
#if sys if (FileSystem.exists(path)) #end
            file = Assets.getText(path);

        if (hadError)
        {
            file = 'trace("Replaced script to continue gameplay");';
            hadError = false;
        }

        interpreter = new Interp();
        parser = new Parser();
        try {
            interpreter.execute(parser.parseString(file));
        } catch(e) {
            Application.current.window.alert("line: " + parser.line, "Unexpected: " + e); //i forgot the parse shit but whatever
            FlxG.resetState();
            hadError = true;
        }

        setVars();
    }

    public function call(Function:String, Arguments:Array<Dynamic>)
    {
        if (interpreter == null || parser == null) return;
        if (!interpreter.variables.exists(Function)) return;

        var shit = interpreter.variables.get(Function);
        Reflect.callMethod(interpreter, shit, Arguments);
    }

    function setVars()
    {
        //classes
        interpreter.variables.set("CoolUtil", CoolUtil);
        interpreter.variables.set("PlayState", PlayState);
        interpreter.variables.set("Paths", Paths);
        interpreter.variables.set("Alphabet", Alphabet);
        interpreter.variables.set("Character", Character);
        interpreter.variables.set("Conductor", Conductor);
        #if desktop
        interpreter.variables.set("Discord", DiscordClient);
        #end
        interpreter.variables.set("Note", Note);
        interpreter.variables.set("Song", Song);
        interpreter.variables.set("Application", Application);
        interpreter.variables.set("Keyboard", Keyboard);
        interpreter.variables.set("Std", Std);
        interpreter.variables.set("Options", OptionsMenu.options);
        #if cpp
        interpreter.variables.set("Lib", Lib);
        #end
        #if sys 
        interpreter.variables.set("System", System); 
        #end
        interpreter.variables.set("Assets", Assets);

        //flx
        interpreter.variables.set("FlxG", FlxG);
        interpreter.variables.set("FlxSprite", FlxSprite);
        interpreter.variables.set("FlxObject", FlxObject);
        interpreter.variables.set("FlxSpriteTypedGroup", function(limit:Int){
            return new FlxTypedGroup<FlxSprite>(limit); //i hate this
        });
        interpreter.variables.set("FlxMath", FlxMath);
        interpreter.variables.set("FlxText", FlxText);
        interpreter.variables.set("FlxSound", FlxSound);
        interpreter.variables.set("FlxTween", FlxTween);
        interpreter.variables.set("FlxEase", FlxEase);
        interpreter.variables.set("FlxTimer", FlxTimer);
    }
}