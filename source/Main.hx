package;

import openfl.events.UncaughtErrorEvents;
import Discord.DiscordClient;
import lime.app.Application;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
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
	
	public static var version = "0.0.1";

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

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
		initialState = Caching;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end

		//some basic shit ig
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUnhandledRejection);
	}

	//ill work on this later faijdvdjkLZC:VGFXDSCKL:
	function onUnhandledRejection(uncaughtRejection:UncaughtErrorEvent) {
		trace("UNHANDLED ERROR");

		var message = "";
		var callStackItems = CallStack.exceptionStack(true);
		for (item in callStackItems)
		{
			switch(item)
			{
				case FilePos(s, file, line, column):
					message += '$file (line $line:$column)\n';
				default:
					Sys.println(item);
			}
		}

		message += "\nError: " + uncaughtRejection.error;

		trace(message);

		Application.current.window.alert(message, "Unhandled Rejection");

		DiscordClient.shutdown();
		Sys.exit(1);
	}
}
