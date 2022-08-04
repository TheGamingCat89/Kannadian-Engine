package;

import flixel.addons.ui.FlxUI;
import flixel.ui.FlxBar;
#if sys
import sys.FileSystem;
#end
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIInputText;
import flixel.math.FlxMath;
import openfl.Assets;
import haxe.Json;
import Character.CharacterData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUITabMenu;

//!!!I AM NOT DONE WITH THIS SO EXPECT IT TO CRASH LOL (ill fix it sometime soon i hope)!!!
class AnimationDebug extends MusicBeatState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var TEST:FlxSprite;
	var icon:HealthIcon;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	//var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'bf';
	var camFollow:FlxObject;
	var charData:CharacterData = null;
	var menu:FlxUITabMenu;

	public function new(daAnim:String = 'bf')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.mouse.visible = true;
		FlxG.sound.music.stop();

		#if sys if (FileSystem.exists(Paths.json("characters/" + daAnim))) #end
			charData = Json.parse(Assets.getText(Paths.json("characters/" + daAnim)));

		if (charData == null)
		{
			charData = {
				name: daAnim,
				animations: [
					{
						name: "idle",
						prefix: "",
						offset: [0, 0],
						frameRate: 24,
						looped: false
					},
					{
						name: "singLEFT",
						prefix: "",
						offset: [0, 0],
						frameRate: 24,
						looped: false
					},
					{
						name: "singDOWN",
						prefix: "",
						offset: [0, 0],
						frameRate: 24,
						looped: false
					},
					{
						name: "singUP",
						prefix: "",
						offset: [0, 0],
						frameRate: 24,
						looped: false
					},
					{
						name: "singRight",
						prefix: "",
						offset: [0, 0],
						frameRate: 24,
						looped: false
					},
				],
				path: "",
				icon: {
					icon: "dad",
					color: "#FFaf66ce"
				},
				antialiasing: true,
				flipped: false
			}
		}

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		#if sys if (FileSystem.exists(Paths.image('characters/' + daAnim, 'shared')) && FileSystem.exists(Paths.xml('characters/' + daAnim, 'shared'))) #end
			TEST.frames = Paths.getSparrowAtlas('characters/' + daAnim, 'shared');
		/*if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}*/

		var tabs =
		[
			{name: "Animation", label: "Animation"},
			{name: "Character", label: "Character"},
		];

		menu = new FlxUITabMenu(null, tabs, true);	
		menu.resize(300, 400);
		menu.x = FlxG.width / 4;
		menu.y = 20;
		add(menu);

		addAnimTab();
		addCharTab();
		
		var healthBarBG = new FlxSprite(50, FlxG.height * 0.95).loadGraphic(Paths.image('healthBar'));
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		var healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, LEFT_TO_RIGHT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, '', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFF00C78B, FlxColor.fromString(charData.icon.color));
		add(healthBar);

		icon = new HealthIcon(daAnim);
		icon.y = healthBarBG.y; icon.x = healthBarBG.x;
		add(icon);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = charData.animations.length - 1;

		if (curAnim >= charData.animations.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(charData.animations[curAnim].name);

			updateTexts();
			genBoyOffsets();
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				charData.animations[curAnim].offset[1] += 1 * multiplier;
			if (downP)
				charData.animations[curAnim].offset[1] -= 1 * multiplier;
			if (leftP)
				charData.animations[curAnim].offset[0] += 1 * multiplier;
			if (rightP)
				charData.animations[curAnim].offset[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets();
			char.playAnim(charData.animations[curAnim].name);
		}

		super.update(elapsed);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUINumericStepper.CHANGE_EVENT && Std.isOfType(sender, FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			if (wname == 'animation_framerate')
				charData.animations[curAnim].frameRate = Std.int(nums.value);
		}
	}

	function genBoyOffsets():Void
	{
		var daLoop:Int = 0;

		dumbTexts.clear();
		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}
	

	function updateChar()
	{
		if (char.curCharacter != charData.name)
		{
			char = new Character(0,0,charData.name);
			
			genBoyOffsets();
		}
		if (icon.char != charData.icon.icon)
		{
			icon = new HealthIcon(charData.icon.icon);
		}
	}

	function addAnimTab()
	{
		var grp = new FlxUI(null, menu);
		grp.name = "Animation";
		//ANIM TAB
		//text input for anim prefix and anim name 	FlxUIInputText
		//framerate num thing 						FlxUINumericStepper
		//looped checkmark 							FlxUICheckBox
		var animNameInput = new FlxUIInputText(10,10, 50, charData.animations[curAnim].name);
		animNameInput.name = "animation_name";
		animNameInput.callback = (text, action) -> {
			if (action == "enter")
				charData.animations[curAnim].name = text;
		}
		grp.add(animNameInput);

		var animPrefixInput = new FlxUIInputText(10,30, 50, charData.animations[curAnim].prefix);
		animPrefixInput.name = "animation_prefix";
		animPrefixInput.callback = (text, action) -> {
			if (action == 'enter')
				charData.animations[curAnim].prefix = text;
		}
		grp.add(animPrefixInput);

		var animFrameRate = new FlxUINumericStepper(290, 10, 1, 24, 0);
		animFrameRate.value = charData.animations[curAnim].frameRate;
		animFrameRate.name = "animation_framerate";
		grp.add(animPrefixInput);

		var animLopped = new FlxUICheckBox(290, 390, null, charData.animations[curAnim].looped, "Looped");
		animLopped.name = "animation_is_looped";
		animLopped.callback = () -> {
			charData.animations[curAnim].looped = animLopped.checked;
		}

		menu.addGroup(grp);
	}

	function addCharTab()
	{
		var grp = new FlxUI(null, menu);
		grp.name = "Character";
		//CHARACTER TAB
		//path text input 							FlxUIInputText
		//character name and icon name 				FlxUIInputText
		//get icon color button 					FlxButton
		//flipped checkmark 						FlxUICheckBox
		//antialiasing checkmark 					FlxUICheckBox
		var charPath = new FlxUIInputText(10,10,50,charData.path);
		charPath.name = "character_path";
		charPath.callback = (text, action) -> {
			if (action == "enter")
				charData.path = text;
			updateChar();
		}
		grp.add(charPath);

		var charName = new FlxUIInputText(10, 30, 50, charData.name);
		charName.name = "character_name";
		charName.callback = (text, action) -> {
			if (action == "enter")
				charData.name = text;
		}
		grp.add(charPath);

		var charIcon = new FlxUIInputText(10, 50, 50, charData.icon.icon);
		charIcon.name = "character_icon_path";
		charIcon.callback = (text, action) -> {
			if (action == "enter")
				charData.icon.icon = text; 
			updateChar();
		}
		grp.add(charIcon);

		var charIconColor = new FlxButton(290, 390, charData.icon.color, () -> {
			charData.icon.color = "#" + CoolUtil.dominantColor(icon).toHexString(true, false);
		});
		charIconColor.label.text = "Get Icon Color";
		grp.add(charIconColor);

		var charFlipped = new FlxUICheckBox(10, 370, null, charData.flipped, "Flipped");
		charFlipped.name = "character_flipped";
		charFlipped.callback = () -> {
			charData.flipped = charFlipped.checked;
		}
		grp.add(charFlipped);

		var charAntialiasing = new FlxUICheckBox(10, 390, null, charData.antialiasing, "Antialiasing");
		charAntialiasing.name = "character_antialiasing";
		charAntialiasing.callback = () -> {
			charData.antialiasing = charAntialiasing.checked;
			char.antialiasing = charData.antialiasing;
		}
		grp.add(charFlipped);

		menu.addGroup(grp);
	}
}
