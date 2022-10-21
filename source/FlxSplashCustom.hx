//todo: make this better
package;

import Discord.DiscordClient;
import flixel.addons.text.FlxTypeText;
import openfl.media.Sound;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;
import openfl.geom.Matrix;
import flixel.addons.display.shapes.FlxShape;
import flixel.FlxSprite;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlxSplashCustom extends FlxState
{
	public static var nextState:Class<FlxState>;

	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;

	var sprite:Sprite; //Sprite
	var gfx:Graphics;
	var text:TextField;

	var times:Array<Float>;
	var colors:Array<Int>;
	var functions:Array<Void->Void>;
	var curPart:Int = 0;
	var cachedBgColor:FlxColor;
	var cachedTimestep:Bool;
	var cachedAutoPause:Bool;

	var coloredBg:Sprite;
	var bgGfx:Graphics;
	@:noPrivateAccess var triggered = false;

	override public function create():Void
	{
		if (!OptionsMenu.options.splashScreen)
		{
			@:privateAccess
			FlxG.game._gameJustStarted = true;
			FlxG.switchState(new TitleState());
			return;
		}

		cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		// This is required for sound and animation to synch up properly
		cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		#if FLX_KEYBOARD
		FlxG.keys.enabled = false;
		#end

		times = [0.041, 0.184, 0.334, 0.495, 0.636];
		colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
		functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		coloredBg = new Sprite();
		FlxG.stage.addChild(coloredBg);
		bgGfx = coloredBg.graphics;

		sprite = new Sprite();
		FlxG.stage.addChild(sprite);
		gfx = sprite.graphics;

		text = new TextField();
		text.selectable = false;
		text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = dtf;
		text.text = "HaxeFlixel";
		FlxG.stage.addChild(text);

		onResize(stageWidth, stageHeight);

		#if FLX_SOUND_SYSTEM
		if (!muted)
			FlxG.sound.play(FlxAssets.getSound("flixel/sounds/flixel"));
		#end

		for (time in times)
			new FlxTimer().start(time, timerCallback);
	}

	override public function destroy():Void
	{
		sprite = null;
		text = null;
		times = null;
		colors = null;
		functions = null;
		coloredBg = null;
		super.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);

		if (!OptionsMenu.options.splashScreen) return;

		sprite.x = (Width / 2);
		sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		text.width = Width / FlxG.game.scaleX;
		text.y = sprite.y + 80 * FlxG.game.scaleY;

		sprite.scaleX = text.scaleX = FlxG.game.scaleX;
		sprite.scaleY = text.scaleY = FlxG.game.scaleY;

		coloredBg.scaleX = Width * 1.5;
		coloredBg.scaleY = Height * 1.5;
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		functions[curPart]();
		curPart++;

		if (curPart == 5)
		{
			text.textColor = 0xFFFFFFFF;
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			FlxTween.tween(sprite, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: onComplete});
			FlxTween.tween(coloredBg, {alpha: 0}, 3.0, {ease: FlxEase.quadOut});
			FlxTween.tween(text, {alpha: 0}, 1.0, {ease: FlxEase.quadOut});
		}
	}

	function drawGreen():Void
	{
		text.textColor = 0xFF000000;
		bgGfx.clear();
		bgGfx.beginFill(0x00b922);
		bgGfx.drawRect(0,0,FlxG.game.width, FlxG.game.height);
		bgGfx.endFill();
		gfx.beginFill(0x00b922);
		gfx.moveTo(0, -37);
		gfx.lineTo(1, -37);
		gfx.lineTo(37, 0);
		gfx.lineTo(37, 1);
		gfx.lineTo(1, 37);
		gfx.lineTo(0, 37);
		gfx.lineTo(-37, 1);
		gfx.lineTo(-37, 0);
		gfx.lineTo(0, -37);
		gfx.endFill();
	}

	function drawYellow():Void
	{
		bgGfx.clear();
		bgGfx.beginFill(0xffc132);
		bgGfx.drawRect(0,0,FlxG.game.width, FlxG.game.height);
		bgGfx.endFill();
		gfx.beginFill(0xffc132);
		gfx.moveTo(-50, -50);
		gfx.lineTo(-25, -50);
		gfx.lineTo(0, -37);
		gfx.lineTo(-37, 0);
		gfx.lineTo(-50, -25);
		gfx.lineTo(-50, -50);
		gfx.endFill();
	}

	function drawRed():Void
	{
		bgGfx.clear();
		bgGfx.beginFill(0xf5274e);
		bgGfx.drawRect(0,0,FlxG.game.width, FlxG.game.height);
		bgGfx.endFill();
		gfx.beginFill(0xf5274e);
		gfx.moveTo(50, -50);
		gfx.lineTo(25, -50);
		gfx.lineTo(1, -37);
		gfx.lineTo(37, 0);
		gfx.lineTo(50, -25);
		gfx.lineTo(50, -50);
		gfx.endFill();
	}

	function drawBlue():Void
	{
		bgGfx.clear();
		bgGfx.beginFill(0x3641ff);
		bgGfx.drawRect(0,0,FlxG.game.width, FlxG.game.height);
		bgGfx.endFill();
		gfx.beginFill(0x3641ff);
		gfx.moveTo(-50, 50);
		gfx.lineTo(-25, 50);
		gfx.lineTo(0, 37);
		gfx.lineTo(-37, 1);
		gfx.lineTo(-50, 25);
		gfx.lineTo(-50, 50);
		gfx.endFill();
	}

	function drawLightBlue():Void
	{
		bgGfx.clear();
		bgGfx.beginFill(0x04cdfb);
		bgGfx.drawRect(0,0,FlxG.game.width, FlxG.game.height);
		bgGfx.endFill();
		gfx.beginFill(0x04cdfb);
		gfx.moveTo(50, 50);
		gfx.lineTo(25, 50);
		gfx.lineTo(1, 37);
		gfx.lineTo(37, 1);
		gfx.lineTo(50, 25);
		gfx.lineTo(50, 50);
		gfx.endFill();
	}

	function onComplete(Tween:FlxTween):Void
	{
		FlxG.cameras.bgColor = cachedBgColor;
		FlxG.fixedTimestep = cachedTimestep;
		FlxG.autoPause = cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		FlxG.stage.removeChild(sprite);
		FlxG.stage.removeChild(text);
		FlxG.stage.removeChild(coloredBg);
		FlxG.switchState(Type.createInstance(nextState, []));
		@:privateAccess
		FlxG.game._gameJustStarted = true;
	}
}
