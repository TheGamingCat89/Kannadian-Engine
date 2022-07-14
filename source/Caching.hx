#if sys
import flixel.graphics.FlxGraphic;
#if cpp
import sys.FileSystem;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

using StringTools;

class Caching extends MusicBeatState
{
	var logo:FlxSprite;

	override function create() 
	{
		FlxG.save.bind('funkin', 'ninjamuffin99');
    
		Highscore.load();
		PlayerSettings.init();
		OptionsData.init();
        OptionsMenu.loadSettings();
        KeyBinds.loadKeybinds();

        if (FlxG.save.data.volume != null)
			FlxG.sound.volume = Std.parseFloat(FlxG.save.data.volume);

	    FlxG.mouse.visible = false;
		FlxG.worldBounds.set(0,0);

		logo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('preloaderArt'));
		logo.setGraphicSize(Std.int(logo.width * 0.3));		
		logo.antialiasing = OptionsMenu.options.antialiasing;
		add(logo);

		#if cpp
		Thread.create(() -> {
			preload();
		});
		#else
		FlxG.switchState(new TitleState());
		#end
	}

	public function preload()
	{
        var blacklist = ['lol.png', 'backspace.png', 'grafix.png', 'lose.png', 'screencapTierImage.png', 'week54prototype.png', 'zzzzzzzz.png', 'logo.png', 'preloaderArt.png'];
		FlxGraphic.defaultPersist = true;

		for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
			    FlxG.bitmap.add(Paths.image(file.split(".")[0], 'shared'));

        for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
                FlxG.bitmap.add(Paths.image(file.split(".")[0]));

		LoadingState.loadAndSwitchState(new TitleState());
	}
}
#end