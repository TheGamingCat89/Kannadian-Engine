package;


#if sys
import Discord.DiscordClient;
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
		FlxG.game.focusLostFramerate = 60;
		FlxG.autoPause = false;

		DiscordClient.initialize();

		logo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('preloaderArt'));
		logo.setGraphicSize(Std.int(logo.width * 0.3));		
		logo.antialiasing = OptionsMenu.options.antialiasing;
		add(logo);

		#if cpp
		Thread.create(() -> {
			preload();
		});
		#else
		LoadingState.loadAndSwitchState(new TitleState());
		#end
	}

	public function preload()
	{
		trace("caching shit");

        var blacklist = ['lol.png', 'backspace.png', 'grafix.png', 'lose.png', 'screencapTierImage.png', 'week54prototype.png', 'zzzzzzzz.png', 'logo.png', 'preloaderArt.png'];
		FlxGraphic.defaultPersist = true;

		for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
			    FlxG.bitmap.add(Paths.image(file.split(".")[0], 'shared'));

        for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
                FlxG.bitmap.add(Paths.image(file.split(".")[0]));

		//I HOPE IT WORKS :SOB:
		for (i in 1...6) //each folder
			for (HII in FileSystem.readDirectory(FileSystem.absolutePath("assets/week" + i))) //HII = images folder
				try { 
					for (fuck in FileSystem.readDirectory(FileSystem.absolutePath(HII)))//IMAGE OR FOLDER INSIDE OF IMAGES FOLDER
					{
						trace(fuck);
						if (fuck.endsWith(".png"))
							FlxG.bitmap.add(Paths.image(fuck.split(".")[0]))
						else {
							try {
								for(file in FileSystem.readDirectory(FileSystem.absolutePath(fuck)))
								{	
									trace(file);
									if (file.endsWith(".png"))
										FlxG.bitmap.add(Paths.image(file.split(".")[0]));
								}
							} catch (e) { trace(e); }
						}
					}
				} catch(e) {trace(e); }

		remove(logo);
		logo.kill();
		logo.destroy();

		LoadingState.loadAndSwitchState(new TitleState());
	}
}
#end