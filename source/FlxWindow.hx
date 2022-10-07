//credits to EIT#1707 woo
package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.tile.FlxDrawBaseItem;
import flixel.system.frontEnds.CameraFrontEnd;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import lime.ui.WindowAttributes;
import lime.ui.Window;

class FlxWindow extends Sprite
{
	public var window:Window;
	var inputContainer:Sprite;
	public static var cameras(default, null):CameraFrontEnd;
	public var camera:FlxCamera;
	
	public function new(x:Int, y:Int, width:Int, height:Int, title:String, frameRate:Int, resizable:Bool, fullscreen:Bool)
	{
		super();
		inputContainer = new Sprite();
		var attributes:WindowAttributes = {
			frameRate: frameRate,
			fullscreen: fullscreen,
			height: height,
			resizable: resizable,
			title: title,
			width: width,
			x: null,
			y: null
		};
		attributes.context = {
			antialiasing: 0,
			background: 0,
			colorDepth: 32,
			depth: true,
			hardware: true,
			stencil: true,
			type: null,
			vsync: false
		};
		window = FlxG.stage.application.createWindow(attributes);
		window.stage.color = FlxColor.BLACK;
		camera = new FlxCamera(0, 0, width, height);

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(?_):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
		create();
	}

	function create()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.frameRate = FlxG.drawFramerate;
		addChild(inputContainer);
		addChildAt(camera.flashSprite, getChildIndex(inputContainer));
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	function onEnterFrame(_):Void
	{
		camera.update(FlxG.elapsed);
		draw();
	}

	@:access(flixel.FlxCamera.render)
	function draw():Void
	{
		camera.update(FlxG.elapsed);
		FlxDrawBaseItem.drawCalls = 0;
        camera.canvas.graphics.clear();
		camera.flashSprite.graphics.clear();
		camera.fill(camera.bgColor.to24Bit(), camera.useBgAlphaBlending, camera.bgColor.alphaFloat);
		camera.render();
	}
}

@:cppFileCode('#include <windows.h>\n#include <dwmapi.h>\n\n#pragma comment(lib, "Dwmapi")')
class FlxTransWindow
{
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(0, 0, 0), 0.1, LWA_COLORKEY);
			//this didnt work lmao
			/*BLENDFUNCTION blend = { 0 };
			blend.BlendOp = AC_SRC_OVER;
			blend.SourceConstantAlpha = 255;
			blend.AlphaFormat = AC_SRC_ALPHA;
			HDC hdcS = GetDC(NULL);
			HDC hdcM = CreateCompatibleDC(hdcS);
			UpdateLayeredWindow(hWnd, hdcS, NULL, NULL, hdcM, {0}, RGB(0,0,0), &blend, ULW_ALPHA);*/
        }
    ')
	static public function getWindowsTransparent(res:Int = 0)
	{
		return res;
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(0, 0, 0), 1, LWA_COLORKEY);
        }
    ')
	static public function getWindowsbackward(res:Int = 0)
	{
		return res;
	}
}