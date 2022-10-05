package;

//i forgot i was doing this LOL
//ill work on it.. later
import haxe.CallStack;
import flixel.util.FlxColor;
import hscript.*;
import lime.app.Application;
import openfl.Assets;
#if sys
import sys.FileSystem;
#end

using StringTools;

class HScript 
{
    public var interpreter:Interp;
    public var variables:Map<String, Dynamic>;
    public var parser:Parser;

    static private var hadError:Bool = false;
    private var checker:Checker;

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
    
        //to use require just do it like this !!!
        // var PlayState = require("PlayState");
        // var Json = require("haxe.Json"); 
        interpreter.variables.set("require", Type.resolveClass);

        parser = new Parser();
        parser.allowJSON = true;
        parser.preprocesorValues.set("sys", #if sys "1" #else "0" #end); //IM NOT SURE HOW THIS WORKS LOL
        parser.preprocesorValues.set("cpp", #if cpp "1" #else "0" #end);

        try {
            checker = new Checker();
            checker.check(parser.parseString(file), null, true);
            interpreter.execute(parser.parseString(file));
        } catch(e) {
            if (e.toString() == "Null Object Reference")
            {
                var m = "", c = CallStack.callStack();
                for (i in c)
                {
                    switch (i)
                    {
                        case FilePos(s, file, line, column):
                            m+='$file (line $line)\n';
                        default:
                    }
                }
                Application.current.window.alert(e + "\n\n" + m + "\n\nRemoving script to continue gameplay.", "Error on HaxeScript");
            }
            else
                Application.current.window.alert('$path ' + e.toString() + "\n\nRemoving script to continue gameplay.", "Error on HaxeScript");

            hadError = true;
        }

        interpreter.variables.set("FlxColorFromString", function(str) {
            var result:Null<FlxColor> = null;
            str = StringTools.trim(str);
            @:privateAccess
            if (FlxColor.COLOR_REGEX.match(str)) {
                var hexColor:String = "0x" + FlxColor.COLOR_REGEX.matched(2);
                result = new FlxColor(Std.parseInt(hexColor));
                if (hexColor.length == 8)
                    result.alphaFloat = 1;
            } else {
                str = str.toUpperCase();
                for (key in FlxColor.colorLookup.keys()) {
                    if (key.toUpperCase() == str) {
                        result = new FlxColor(FlxColor.colorLookup.get(key));
                        break;
                    }
                }
            }
            return result;
        });
    }

    public function call(Function:String, Arguments:Array<Dynamic>)
    {
        if (interpreter == null || parser == null) return;
        if (!interpreter.variables.exists(Function)) return;

        var shit = interpreter.variables.get(Function);
        try Reflect.callMethod(interpreter, shit, Arguments) catch(e)0;
    }
}