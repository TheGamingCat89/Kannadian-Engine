package;

import haxe.rtti.Meta;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.events.EventType;
import openfl.events.Event;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;
	
	private var controls(get, never):Controls;

	public var hscript:Array<HScript> = [];

	public var instance:Dynamic;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		instance = this;

		hscript.push(new HScript(Paths.hscript("classes/Override/" + Type.getClassName(Type.getClass(this)) + "Script")));

		for (script in hscript)
			script.call("create");

		if (transIn != null)
			trace('reg ' + transIn.region);

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

		super.create();
	}

	override function destroy()
	{
		for (script in hscript)
			script.call("destroy");

		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		super.destroy();
	}

	private function keyDown(event:KeyboardEvent)
	{
		for (script in hscript)
			script.call("keyDown", [event]);
	}

	private function keyUp(event:KeyboardEvent)
	{
		for (script in hscript)
			script.call("keyUp", [event]);
	}

	override function update(elapsed:Float)
	{
		for (script in hscript)
			script.call("update", [elapsed]);

		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	override function onFocus()
	{
		for (script in hscript)
			script.call("onFocus", []);

		super.onFocus();
	}

	override function onFocusLost()
	{
		for (script in hscript)
			script.call("onFocusLost", []);

		super.onFocusLost();
	}

	public function stepHit():Void
	{
		for (script in hscript)
			script.call("stepHit");

		try if (curStep % 4 == 0) beatHit();
	}

	public function beatHit():Void
	{
		for (script in hscript)
			script.call("beatHit");
	}

}
