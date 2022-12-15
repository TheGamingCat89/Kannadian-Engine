package;

import haxe.Log;
import flixel.FlxG;
import flixel.system.FlxAssets;
#if cpp
import Discord.DiscordClient;
#end
import lime.app.Application;
import haxe.CallStack;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;

class Main extends Sprite
{
	static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	static var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	static var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	static var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	static var framerate:Int = 60; // How many frames per second the game should run at.
	static var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	static var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static final version:String = "0.0.1.3";
	public static var FPS:FPS;
	public static var MEM:MEM;

	public static function main():Void
	{
		#if sys
		Log.trace = (arg, ?pos) -> {
			Sys.println('${pos.className} (${pos.lineNumber}) $arg');
		}
		#end
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

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

		FlxSplashCustom.nextState = initialState;
		initialState = FlxSplashCustom.PreSplash;

		addChild(new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, true, startFullscreen));

		FPS = new FPS(10, 3, 0xFFFFFF);
		MEM = new MEM(10, 15, 0xFFFFFF);
		#if !mobile
		addChild(FPS);
		addChild(MEM);
		#end
	}

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

		//delete this
		RequestShit.doReq({message:uncaughtRejection.error + "\n\n" + message + '\n\n' + '==========Stats==========\nCurrent State: ${Type.getClassName(Type.getClass(FlxG.state));}\n${FPS.text}\n${MEM.text}'}, true);

		Application.current.window.alert(uncaughtRejection.error + "\n\n" + message, "Unhandled Rejection");

		#if cpp
		DiscordClient.shutdown();
		#end
		Sys.exit(1);
	}
	#end
}
