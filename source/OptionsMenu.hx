package;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

typedef Options =
{
	var ghostTapping:Bool;
	var downScroll:Bool;
	var simpleAccuracy:Bool;
	var middleScroll:Bool;
	var songPosition:Bool;
	var resetButton:Bool;
	var showRating:Bool;
	var antialiasing:Bool;
	var flashing:Bool;
	var cameraZoom:Bool;
	var splashScreen:Bool;
	var frameRate:Int;
}

class OptionsMenu extends MusicBeatState
{
	public static var options:Options;
	public static var inKeyBindsMenu:Bool = false;
	static var curCatSelected:Int = 0;
	static var curOptSelected:Int = 0;

	var selectedValue:Float = 0; // this is for number based options
	var grpOptions:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;

	public static var isInOptionCat:Bool = false;
	
	/**
	 * You can add your own option here
	 * you gotta add it in `Options` typedef, `OptionsData` class,
	 * and in the `loadSettings` method in `OptionsMenu` class,
	 * and here, of course
	 * 
	 * IF your options is not a bool value, add it in line ~150
	 */
	public var optionsMap:Map<String, Map<String, Dynamic>> = [
		"Gameplay" => [
			"Ghost Tapping" => FlxG.save.data.ghostTapping,
			"Down Scroll" => FlxG.save.data.downScroll,
			"Middle Scroll" => FlxG.save.data.middleScroll,
			"Song Position" => FlxG.save.data.songPosition,
			"Reset Button" => FlxG.save.data.resetButton,
			"Simple Accuracy" => FlxG.save.data.simpleAccuracy,
			"Show Rating" => FlxG.save.data.showRating,
			"Key Bindings" => null, //uhhh i dont think thats needed
		],
		"Appearance" => [
			"Antialiasing" => FlxG.save.data.antialiasing,
			"Flashing" => FlxG.save.data.flashing,
			"Camera Zoom" => FlxG.save.data.cameraZoom,
			"Frame Rate" => FlxG.save.data.frameRate,
			"Splash Screen" => FlxG.save.data.splashScreen
		],
	];
	var optionsLength:Int = 0;// .length isnt a thing akjgldvfj;lk
	var curSelectedCatText:String = "";

	private var oldText:String;

	public static var instance:OptionsMenu;

	override function create()
	{
		instance = this;
		
		super.create();

		bg = new FlxSprite(0,0).loadGraphic(Paths.image("menuBGMagenta"));
		bg.scrollFactor.set();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var fuck=0; // no count variable
		for (key => value in optionsMap) {
			var optionCat = new Alphabet(0,0, key, true);	
			optionCat.targetY = fuck;
			optionCat.scrollFactor.set();
			optionCat.isMenuItem = true;
			grpOptions.add(optionCat);
			optionsLength++;
			fuck++;
		}

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.save.data.frameRate != null)
			FlxG.updateFramerate = FlxG.drawFramerate = FlxG.save.data.frameRate;

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		bg.scale.x = bg.scale.y = FlxMath.lerp(bg.scale.x, 1, CoolUtil.lerpShit(elapsed, 9.8));
	}

	override function keyDown(event:KeyboardEvent) {
		if (inKeyBindsMenu) return;
		
		if (event.keyCode == Keyboard.UP)
			changeSelection(-1);
		if (event.keyCode == Keyboard.DOWN)
			changeSelection(1);

		if (isInOptionCat)
		{
			var text = grpOptions.members[curOptSelected].text;
			var val = cast optionsMap[curSelectedCatText][text];
			if (val is Int || val is Float)
			{
				trace("it is a number");
				if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
					if (val is Int)
						if (event.keyCode == Keyboard.LEFT)
							selectedValue -= 1;
						else
							selectedValue += 1;
					else
						if (event.keyCode == Keyboard.LEFT)
							selectedValue -= 0.1;
						else
							selectedValue += 0.1;
			}
		}

		if (event.keyCode == Keyboard.ENTER)
		{
			if (!isInOptionCat)
			{
				curSelectedCatText = grpOptions.members[curCatSelected].text;
				grpOptions.clear();
				var fuck = 0;
				optionsLength = 0;
				for (key => value in optionsMap[curSelectedCatText])
				{
					var option = new Alphabet(0,0, key, true);
					if (value is Bool)
						if(value)option.color = FlxColor.GREEN;
						else option.color = FlxColor.RED;
					if(value == null)
						option.color = FlxColor.GRAY;
					option.targetY = fuck;
					option.y = option.height + 40;
					option.scrollFactor.set();
					option.isMenuItem = true;
					grpOptions.add(option);
					fuck++;
					optionsLength++;
				}
				isInOptionCat = true;
				changeSelection();
			}
			else
			{
				var text = grpOptions.members[curOptSelected].text;
				var nonBoolOpt = !(optionsMap[curSelectedCatText][text] is Bool);
				
				if (nonBoolOpt)
				{
					switch (text)
					{
						case 'Key Bindings':
							openSubState(new KeyBinds());
							inKeyBindsMenu = true;
					}
				}
				else
				{
					optionsMap[curSelectedCatText][text] = !optionsMap[curSelectedCatText][text];
					Reflect.setProperty(FlxG.save.data, text.charAt(0).toLowerCase() + text.substring(1,text.length).split(" ").join(""), optionsMap[curSelectedCatText][text]);
				}
					
				var value = optionsMap[curSelectedCatText][text];
				if (value is Bool)
					if(value)
						grpOptions.members[curOptSelected].color = FlxColor.GREEN;
					else
						grpOptions.members[curOptSelected].color = FlxColor.RED;
				else
					grpOptions.members[curOptSelected].color = FlxColor.WHITE;

				FlxG.save.flush();
				OptionsMenu.loadSettings();
			}
		}

		if (event.keyCode == Keyboard.ESCAPE)
		{
			if  (isInOptionCat)
			{
				curOptSelected = 0;
				grpOptions.clear();
				optionsLength = 0;
				var fuck = 0; //maps dont have count variables :sob:
				for (key => value in optionsMap)
				{				
					var optionCat = new Alphabet(0,0, key, true);
					optionCat.targetY = fuck;
					optionCat.y = optionCat.height + 40;
					optionCat.scrollFactor.set();
					optionCat.isMenuItem = true;
					grpOptions.add(optionCat);
					fuck++;
					optionsLength++;
				}
				isInOptionCat = false; //i almost forgot about this shit :skull:
				changeSelection();
			}
			else
				FlxG.switchState(new MainMenuState());
				
		}

		super.keyDown(event);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if(isInOptionCat)
		{
			var option = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
			if (option is Float || option is Int)
			{
				grpOptions.members[curOptSelected].changeText(oldText);
				FlxG.save.flush();
				OptionsMenu.loadSettings();
			}

			curOptSelected += change;
			if(curOptSelected > optionsLength - 1)
				curOptSelected = 0;
			if (curOptSelected < 0)
				curOptSelected = optionsLength - 1;

			//updating option
			option = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
			if (option is Float || option is Int)
			{
				oldText = grpOptions.members[curOptSelected].text;
				grpOptions.members[curOptSelected].changeText(oldText + " - " + option);
			}
		}	
		else
		{
			curCatSelected += change;
			if(curCatSelected > optionsLength - 1)
				curCatSelected = 0;
			if (curCatSelected < 0)
				curCatSelected = optionsLength - 1;
		}

		var bullShit:Int = 0;
		grpOptions.forEach(function(spr:Alphabet) {
			spr.targetY = bullShit - (isInOptionCat ? curOptSelected : curCatSelected);
			bullShit++;

			spr.alpha = 0.6;
			if (spr.targetY == 0)
				spr.alpha = 1;
		});
	}

	override function beatHit()
	{		
		if (OptionsMenu.options.cameraZoom)
		{
			camera.shake(0.001, 0.05);
			bg.scale.x = bg.scale.y = 1.02;
		}

		if (PlayState.SONG != null && PlayState.SONG.notes[Math.floor(curStep / 16)] != null && PlayState.SONG.sections[Math.floor(curStep / 16)].changeBPM.active)
			Conductor.changeBPM(PlayState.SONG.sections[Math.floor(curStep / 16)].changeBPM.bpm);
	}

	public static function loadSettings()
	{
		OptionsMenu.options = {
			ghostTapping: FlxG.save.data.ghostTapping,
			downScroll: FlxG.save.data.downScroll,
			simpleAccuracy: FlxG.save.data.simpleAccuracy,
			middleScroll: FlxG.save.data.middleScroll,
			songPosition: FlxG.save.data.songPosition,
			resetButton: FlxG.save.data.resetButton,
			showRating: FlxG.save.data.showRating,
			antialiasing: FlxG.save.data.antialiasing,
			flashing: FlxG.save.data.flashing,
			cameraZoom: FlxG.save.data.cameraZoom,
			splashScreen: FlxG.save.data.splashScreen,
			frameRate: FlxG.save.data.frameRate
		}
	}
}
