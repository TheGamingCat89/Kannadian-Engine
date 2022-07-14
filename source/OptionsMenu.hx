package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

typedef Options =
{
	@:optional public var ghostTapping:Bool;
	@:optional public var downScroll:Bool;
	@:optional public var simpleAccuracy:Bool;
	@:optional public var middleScroll:Bool;
	@:optional public var songPosition:Bool;
	@:optional public var resetButton:Bool;
	@:optional public var antialiasing:Bool;
	@:optional public var flashing:Bool;
	@:optional public var cameraZoom:Bool;
}

class OptionsMenu extends MusicBeatState
{
	public static var options:Options;
	static var curCatSelected:Int = 0;
	static var curOptSelected:Int = 0;
	var grpOptions:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;

	public static var isInOptionCat:Bool = false;
	
	//general options
	public var optionsMap:Map<String, Map<String, Dynamic>> = [
		"Gameplay" => [
			"Ghost Tapping" => FlxG.save.data.ghostTapping,
			"Down Scroll" => FlxG.save.data.downScroll,
			"Middle Scroll" => FlxG.save.data.middleScroll,
			"Song Position" => FlxG.save.data.songPosition,
			"Reset Button" => FlxG.save.data.resetButton,
			"Simple Accuracy" => FlxG.save.data.simpleAccuracy,
			"Key Bindings" => null //uhhh i dont think thats needed
		],
		"Appearance" => [
			"Antialiasing" => FlxG.save.data.antialiasing,
			"Flashing" => FlxG.save.data.flashing,
			"Camera zoom" => FlxG.save.data.cameraZoom,
		],
	];
	var optionsLength:Int = 0;// .length isnt a thing akjgldvfj;lk
	var curSelectedCatText:String = "";

	override function create()
	{
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

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.UP)
			changeSelection(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
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
					if (Std.isOfType(value, Bool))
						if(value)option.color = FlxColor.GREEN;
						else option.color = FlxColor.RED;
					if(value == null)
						option.color = FlxColor.WHITE;
					option.targetY = fuck;
					option.y = option.height + 40;
					option.scrollFactor.set();
					option.isMenuItem = true;
					grpOptions.add(option);
					fuck++;
					optionsLength++;
				}
				isInOptionCat = true;
			}
			else
			{
				//im so fucking sorry for this oh my god
				//ill find a way to optimize it.. i hope
				//wish FlxG.save.data["thing"] was a Map fr				
				switch(grpOptions.members[curOptSelected].text)
				{
					case "Ghost Tapping":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.ghostTapping = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Down Scroll":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.downScroll = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Middle Scroll":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.middleScroll = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Song Position":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.songPosition = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Reset Button":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.resetButton = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Simple Accuracy":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.simpleAccuracy = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Key Bindings":
						openSubState(new KeyBinds());
					case "Antialiasing":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.antialiasing = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Flashing":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.flashing = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
					case "Camera zoom":
						optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text] = !optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
						FlxG.save.data.cameraZoom = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
				}
				//hopefully works? dont mind the mess
				var value = optionsMap[curSelectedCatText][grpOptions.members[curOptSelected].text];
				if (Std.isOfType(value, Bool))
					if(value) grpOptions.members[curOptSelected].color = FlxColor.GREEN;
					else grpOptions.members[curOptSelected].color = FlxColor.RED;
				if(value == null)
					grpOptions.members[curOptSelected].color = FlxColor.WHITE;

				FlxG.save.flush();
				OptionsMenu.loadSettings();
			}
		}

		if (controls.BACK)
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
			}
			else
				FlxG.switchState(new MainMenuState());
				
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if(isInOptionCat)
		{
			curOptSelected += change;
			if(curOptSelected > optionsLength - 1)
				curOptSelected = 0;
			if (curOptSelected < 0)
				curOptSelected = optionsLength - 1;
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
		if (!OptionsMenu.options.cameraZoom)
		{
			camera.shake(0.001, 0.05);
			bg.scale.set(1.02, 1.02);
			FlxTween.tween(bg.scale, {x: 1, y: 1}, 0.05, {ease: FlxEase.sineIn});
		}
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
			antialiasing: FlxG.save.data.antialiasing,
			flashing: FlxG.save.data.flashing,
			cameraZoom: FlxG.save.data.cameraZoom
		}
	}
}
