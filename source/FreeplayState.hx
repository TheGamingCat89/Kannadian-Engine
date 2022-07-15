package;

import OptionsMenu.Options;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.system.FlxSound;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
import flixel.input.gamepad.FlxGamepad;
import Character;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var weeks:Array<WeekMetadata> = null;

	public static var curWeekSelected:Int = 0;
	public static var curSongSelected:Int = 0;
	public static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	var bg:FlxSprite;
	var scoreBG:FlxSprite;
	
	#if PRELOAD_ALL
	var text:FlxText;
	var textBG:FlxSprite;
	var size:Int = 16;
	#end

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpIcons:FlxTypedGroup<HealthIcon>;

	public static var curWeek:Int = 0;
	public static var songData:Map<String,Array<SwagSong>> = [];

	public static var isWeek:Bool = true;

	//color tweening bg thing
	var colorTween:FlxTween = null;
	var iconColor:String;

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try {
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		} catch(ex) {
			trace(ex);
		}
	}

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		songData = [];

		weeks = [];
		
		//loading data
		for (list in initSonglist) // each week
		{
			var weekData:Array<String> = list.split('/')[0].split(":");
			var songsData:Array<String> = list.split('/')[1].split(":");
	
			var weekSongsShit:Array<FreeplaySongMetadata> = [];
	
			for (pre in songsData) // each song per week
			{
				var data = pre.split("=");
				var meta = new FreeplaySongMetadata(data[0], data[1]);
				
				var diffs = [];
				var diffsThatExist = [];
				
				#if sys
				if (FileSystem.exists('assets/data/${meta.songName}/${meta.songName}-hard.json'))
					diffsThatExist.push("Hard");
				if (FileSystem.exists('assets/data/${meta.songName}/${meta.songName}-easy.json'))
					diffsThatExist.push("Easy");
				if (FileSystem.exists('assets/data/${meta.songName}/${meta.songName}.json'))
					diffsThatExist.push("Normal");
				if (diffsThatExist.length == 0)
				{
					Application.current.window.alert("No difficulties found for chart, skipping.",meta.songName + " Chart");
					continue;
				}
				#else
				diffsThatExist = ["Easy","Normal","Hard"];
				#end
				if (diffsThatExist.contains("Easy"))
					FreeplayState.loadDiff(0,meta.songName,meta.songName,diffs);
				if (diffsThatExist.contains("Normal"))
					FreeplayState.loadDiff(1,meta.songName,meta.songName,diffs);
				if (diffsThatExist.contains("Hard"))
					FreeplayState.loadDiff(2,meta.songName,meta.songName,diffs);
			
				meta.diffs = diffsThatExist;
	
				if (diffsThatExist.length != 3)
					trace("ONLY FOUND " + diffsThatExist + "DIFFICULTIES??");
			
				FreeplayState.songData.set(meta.songName,diffs);
				trace('loaded diffs for ' + meta.songName);
	
				weekSongsShit.push(meta);
			}
			
			weeks.push(new WeekMetadata(weekData[0], Std.parseInt(weekData[1]), songsData[0].split("=")[1], weekSongsShit));
		}

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		if(!OptionsMenu.options.flashing)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'))
		else
			bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = OptionsMenu.options.antialiasing;
		add(bg);

        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);    

		grpIcons = new FlxTypedGroup<HealthIcon>();
		add(grpIcons);

		if (isWeek)
		{
			for (i => week in weeks)
			{
				var weekText:Alphabet = new Alphabet(0, (70 * i) + 30, week.weekName, true);
				weekText.isMenuItem = true;
				weekText.targetY = i;
				grpSongs.add(weekText);
			
				var icon:HealthIcon = new HealthIcon(week.weekCharacter);
				icon.sprTracker = weekText;
				grpIcons.add(icon);
			}
		}	
		else
		{
			for (i => song in weeks[curWeekSelected].songs)
			{
				var weekText:Alphabet = new Alphabet(0, (70 * i) + 30, song.songName, true, false);
				weekText.isMenuItem = true;
				weekText.targetY = i;
				grpSongs.add(weekText);
				
				var icon:HealthIcon = new HealthIcon(song.songCharacter);
				icon.sprTracker = weekText;
				grpIcons.add(icon);
			}
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);	

		#if PRELOAD_ALL
		textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "Press SPACE to listen to this song", size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		add(text);

		FlxTween.tween(text, {y: FlxG.height - 18}, 2, {ease: FlxEase.elasticInOut});
		FlxTween.tween(textBG, {y: FlxG.height - 18}, 2, {ease: FlxEase.elasticInOut});
		#end

		changeSelection();
		changeDiff();

		super.create();
	}

	public function addWeek(weekName:String, songs:Array<FreeplaySongMetadata>, weekNum:Int)
		weeks.push(new FreeplayState.WeekMetadata(weekName, weekNum, songs[0].songCharacter, songs));		

	var instPlaying:String = '';
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{

			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}
		}

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK)
		{
			if (colorTween != null)
				colorTween.cancel();

			if(!isWeek)
			{			
				isWeek = true;
				grpSongs.clear();
				grpIcons.clear();
				for (i => week in weeks)
				{
					var weekText:Alphabet = new Alphabet(0, (70 * i) + 30, week.weekName, true, false);
					weekText.isMenuItem = true;
					weekText.targetY = i;
					grpSongs.add(weekText);
				
					var icon:HealthIcon = new HealthIcon(week.weekCharacter);
					icon.sprTracker = weekText;
					grpIcons.add(icon);
				}
				curSongSelected = 0;
				changeSelection();
			}
			else
				FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			if (colorTween != null)
				colorTween.cancel();
			if (isWeek)
			{
				//this should work?
				isWeek = false;
				grpSongs.clear();
				grpIcons.clear();
				for (i => song in weeks[curWeekSelected].songs)
				{
					var songLabel:Alphabet = new Alphabet(0, (70 * i) + 30,song.songName, true, false);
					songLabel.isMenuItem = true;
					songLabel.targetY = i;
					grpSongs.add(songLabel);

					var icon:HealthIcon = new HealthIcon(song.songCharacter);
					icon.sprTracker = songLabel;
					grpIcons.add(icon);
				}
				curSongSelected = 0;
				changeSelection();
			}
			else
			{	
				var poop:String = Highscore.formatSong(weeks[curWeekSelected].songs[curSongSelected].songName.toLowerCase(), curDifficulty);
			
				PlayState.SONG = Song.loadFromJson(poop, weeks[curWeekSelected].songs[curSongSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = weeks[curWeekSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		if(FlxG.keys.justPressed.SPACE)
		{
			#if PRELOAD_ALL
			if(instPlaying != weeks[curWeekSelected].songs[curSongSelected].songName.toLowerCase() && !isWeek)
			{
				var song;
				try
				{
					song = songData.get(weeks[curWeekSelected].songs[curSongSelected].songName)[curDifficulty];
					if (song != null)
					{
						Conductor.changeBPM(song.bpm);
						FlxG.sound.playMusic(Paths.inst(song.song), 0.7);
					}		
				} catch(ex) { 
					text.text = 'There was an error trying to play ' + weeks[curWeekSelected].songs[curSongSelected].songName;
					new FlxTimer().start(1, tmr -> {
						text.text = "Press SPACE to listen to this song";
					});
					trace(ex); 
				}

				FlxG.sound.music.volume = 0;
	
				instPlaying = weeks[curWeekSelected].songs[curSongSelected].songName.toLowerCase();
	
				text.text = 'Playing ' + weeks[curWeekSelected].songs[curSongSelected].songName + '!';
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					text.text = "Press SPACE to listen to this song";
				});
			} else if (isWeek)
				trace("this is a week, it doesnt have a song to load")
			else
			{
				text.text = 'This song is already playing!';
				new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					text.text = "Press SPACE to listen to this song";
				});
			}
			#end
		}
	}
    
	var diffs = ["Easy", "Normal", "Hard"];
	function changeDiff(change:Int = 0)
	{
		if (isWeek) return;

		if (!weeks[curWeekSelected].songs[curSongSelected].diffs.contains(diffs[curDifficulty + change]))
			return;

		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		
		#if !switch
		intendedScore = Highscore.getScore(weeks[curWeekSelected].songs[curSongSelected].songName, curDifficulty);
		#end
		
		diffText.text = diffs[curDifficulty].toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		(isWeek ? curWeekSelected += change : curSongSelected += change);
		if (isWeek)
		{
			if (curWeekSelected < 0)
				curWeekSelected = weeks.length - 1;
			if (curWeekSelected >= weeks.length)
				curWeekSelected = 0;
		}			
		else 
		{
			if (curSongSelected < 0)
				curSongSelected = weeks[curWeekSelected].songs.length - 1;
			if (curSongSelected >= weeks[curWeekSelected].songs.length)
				curSongSelected = 0;
		}		

		if (weeks[curWeekSelected].songs[curSongSelected].diffs.length != 3)
		{
			switch(weeks[curWeekSelected].songs[curSongSelected].diffs[0])
			{
				case "Easy":
					curDifficulty = 0;
				case "Normal":
					curDifficulty = 1;
				case "Hard":
					curDifficulty = 2;
			}
		}
		
		scoreBG.visible = !isWeek;
		scoreText.visible = !isWeek;
		diffText.visible = !isWeek;
		#if PRELOAD_ALL
		text.visible = !isWeek;
		textBG.visible = !isWeek;
		#end

		#if !switch
		intendedScore = Highscore.getScore(weeks[curWeekSelected].songs[curSongSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...grpIcons.members.length)
			grpIcons.members[i].alpha = 0.6;
		grpIcons.members[(isWeek ? curWeekSelected : curSongSelected)].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - (isWeek ? curWeekSelected : curSongSelected);
			bullShit++;
    
			item.alpha = 0.6;
    
			if (item.targetY == 0)
				item.alpha = 1;
		}
		
		if(OptionsMenu.options.flashing){
			//uh??
			var colorSheet:Array<String> = CoolUtil.coolTextFile(Paths.txt('iconColor'));		
			for (data in colorSheet)
			{
				var colorData:Array<String> = data.split(':');
    			if(colorData[0] == (isWeek ? weeks[curWeekSelected].weekCharacter : weeks[curWeekSelected].songs[curSongSelected].songCharacter))
					iconColor = colorData[1];
			}

			if (bg.color != FlxColor.fromString("#FF" + iconColor))
			{
				if (colorTween != null)
					colorTween.cancel();

				colorTween = FlxTween.color(bg, 1, bg.color, FlxColor.fromString("#FF" + iconColor), {ease: FlxEase.sineInOut,
					onComplete: twn -> {
						colorTween = null;
					} 
				});
			}
			
		}
	}

	override function beatHit()
	{
		super.beatHit();

		var zoomShit:Float = 0;

		//add your song here if you want them to have extra zoom on beat
		switch(weeks[curWeekSelected].songs[curSongSelected].songName.toLowerCase()){
			case 'milf':
				zoomShit = 0.08;
			default:
				zoomShit = 0.04;
		}
		var icon = grpIcons.members[(isWeek ? curWeekSelected :curSongSelected)];
		icon.scale.set(icon.scale.x + zoomShit * 6, icon.scale.y + zoomShit * 6);
		FlxTween.tween(grpIcons.members[(isWeek ? curWeekSelected :curSongSelected)].scale, {x: 1, y: 1}, 0.1);

		if (OptionsMenu.options.cameraZoom) //not zoom but anyway
		{
			bg.scale.x += zoomShit;
			bg.scale.y += zoomShit;	
			FlxTween.tween(bg.scale, {x: 1, y: 1}, 0.1);
			FlxG.camera.shake(0.0025, 0.1);
		}	
	}
}

class WeekMetadata
{
	public var weekName:String = "";
	public var week:Int = 0;
	public var weekCharacter:String = "";
	public var songs:Array<FreeplaySongMetadata> = [];

	public function new(weekName:String, week:Int, weekCharacter:String, songs:Array<FreeplaySongMetadata>)
    {
		this.weekName = weekName;
		this.week = week;
		this.weekCharacter = weekCharacter;
		this.songs = songs;
	}
}

class FreeplaySongMetadata
{
	public var songName:String = "";
	public var songCharacter:String = "";

	public var diffs = [];

	public function new(song:String, songCharacter:String)
	{
		this.songName = song;
		this.songCharacter = songCharacter;
	}
}
