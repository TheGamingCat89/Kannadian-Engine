package;


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
		logo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('preloaderArt'));
		logo.setGraphicSize(Std.int(logo.width * 0.3));		
		logo.antialiasing = OptionsMenu.options.antialiasing;
		add(logo);

		#if (cpp && PRELOAD_ALL)
		Thread.create(() -> {
			preload();
		});
		#else
		LoadingState.loadAndSwitchState(new TitleState());
		#end
	}

	private function preload()
	{
		//this is not good i dont want too much ram consumption, i'd rather have stuff load between states
		/*trace("caching shit");

        var blacklist = ['lol.png', 'backspace.png', 'grafix.png', 'lose.png', 'screencapTierImage.png', 'week54prototype.png', 'zzzzzzzz.png', 'logo.png', 'preloaderArt.png'];
		FlxGraphic.defaultPersist = true;

		for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
			    FlxG.bitmap.add(Paths.image(file.split(".")[0], 'shared'));

        for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
            if (file.endsWith(".png") && !blacklist.contains(file))
                FlxG.bitmap.add(Paths.image(file.split(".")[0]));

		for(file in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			if (file.endsWith(".png"))
				FlxG.bitmap.add(Paths.image('characters/' + file.split(".")[0], 'shared'));

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
				} catch(e) {trace(e); }*/

		LoadingState.loadAndSwitchState(new TitleState());
	}
}