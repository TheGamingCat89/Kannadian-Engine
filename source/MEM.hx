package;

import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

class MEM extends TextField
{
	public var currentMEMORY(default, null):Int;
    public var peakMEMORY(default, null):Int;

    private var currentTime:Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentMEMORY = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "MEM: \nPEAK: ";

        currentTime = 0;

		addEventListener(Event.ENTER_FRAME, e ->
        {
            __enterFrame(Lib.getTimer() - currentTime);
        });
	}

	private override function __enterFrame(deltaTime:Float):Void
	{
        currentTime += deltaTime;
		currentMEMORY = System.totalMemory;

        if (currentMEMORY > peakMEMORY) peakMEMORY = currentMEMORY;

		text = "MEM: " + format(currentMEMORY) + "\nPEAK: " + format(peakMEMORY);
	}

    //credits to yce yeaa
    public static function format(num:UInt):String
    {
        var size:Float = num;
        var data = 0;
        var dataTexts = ["B", "KB", "MB", "GB", "TB", "PB"];
        while(size > 1024 && data < dataTexts.length - 1) {
          data++;
          size = size / 1024;
        }
        
        size = Math.round(size * 100) / 100;
        return size + " " + dataTexts[data];
    }
}