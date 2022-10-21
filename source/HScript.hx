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
        parser.allowTypes = true;
        
        parser.preprocesorValues.set("sys", #if sys true #else false #end);
        parser.preprocesorValues.set("cpp", #if cpp true #else false #end);
        parser.preprocesorValues.set("PRELOAD_ALL", #if PRELOAD_ALL true #else false #end);
        parser.preprocesorValues.set("NO_PRELOAD_ALL", #if NO_PRELOAD_ALL true #else false #end);
        parser.preprocesorValues.set("htlm5", #if html5 true #else false #end);
        parser.preprocesorValues.set("flash", #if flash true #else false #end);
        parser.preprocesorValues.set("mobile", #if mobile true #else false #end);
        parser.preprocesorValues.set("desktop", #if desktop true #else false #end);
        parser.preprocesorValues.set("debug", #if debug true #else false #end);
        parser.preprocesorValues.set("web", #if web true #else false #end);
        parser.preprocesorValues.set("js", #if js true #else false #end);

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
                        case FilePos(s, file, line, c):
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

    public function call(Function:String, ?Arguments:Array<Dynamic>)
    {
        if (interpreter == null || parser == null) return;
        if (!interpreter.variables.exists(Function)) return;

        if (Arguments == null) Arguments = [];

        var shit = interpreter.variables.get(Function);
        try Reflect.callMethod(interpreter, shit, Arguments);
    }
}