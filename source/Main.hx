package;

import haxe.macro.PositionTools;
import haxe.macro.Expr.Position;
import haxe.exceptions.PosException;
import flixel.FlxG;
import lime.system.System;
import openfl.text.TextField;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvents;
#if cpp
import Discord.DiscordClient;
#end
import lime.app.Application;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import haxe.io.Path;
#if sys
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
#end
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 144; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static final version:String = "0.0.1.2";
	public static var FPS:FPS;
	public static var MEM:MEM;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		//some basic shit ig
		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUnhandledRejection);
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if desktop
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		FPS = new FPS(10, 3, 0xFFFFFF);
		MEM = new MEM(10, 15, 0xFFFFFF);
		#if !mobile
		addChild(FPS);
		addChild(MEM);
		#end
	}

	//ok cool it works now
	#if sys
	function onUnhandledRejection(uncaughtRejection:UncaughtErrorEvent) {
		var message = "";
		var callStackItems = CallStack.exceptionStack(true);
		for (item in callStackItems)
		{
			switch(item)
			{
				case FilePos(s, file, line, column):
					message += '$file (line $line)\n';
				default:
					trace(item);
			}
		}

		//haha fuck you
		RequestShit.doReq({message:uncaughtRejection.error + "\n\n" + message + '\n\n' + '==========Stats==========\n${FPS.text}\n${MEM.text}'}, true);

		Application.current.window.alert(uncaughtRejection.error + "\n\n" + message, "Unhandled Rejection");

		#if cpp
		DiscordClient.shutdown();
		#end
		Sys.exit(1);
	}
	#end
}
