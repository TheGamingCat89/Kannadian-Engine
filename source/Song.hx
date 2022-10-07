package;

import Section.SwaggiestSection;
import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

//support for old and new chart shit
typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
}

typedef SwaggiestSong =
{
	var song:String;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;
	var player1:String;
	var player2:String;
	var validScore:Bool;

	var notes:Array<SwagNote>;
	var sections:Array<SwaggiestSection>;

	var chartVersion:String;
}

typedef SwagNote =
{
	var noteData:Int;
	var sustainLength:Float;
	var strumTime:Float;
	//var mustHit:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagNote>;
	public var sections:Array<SwaggiestSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, sections, notes, bpm)
	{
		this.song = song;
		this.sections = sections;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwaggiestSong
	{
		var rawJson = Assets.getText(Paths.json('data/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwaggiestSong
	{
		var parsedShit:Dynamic = cast Json.parse(rawJson).song;
		var swagShit:SwaggiestSong;

		//just checking for old charts
		if	(parsedShit.chartVersion == null || parsedShit.chartVersion != "1.5")
			swagShit = translate(cast parsedShit);
		else 
			swagShit = cast parsedShit;
		
		swagShit.validScore = true;
		return swagShit;
	}

	public static function translate(song:SwagSong):SwaggiestSong
	{
		//the only thing that really changes are how notes and sections work
		var swagNotes:Array<SwagNote> = [];
		var swagSections:Array<SwaggiestSection> = [];
		for (i => sec in song.notes)
		{
			swagSections.push(
				{
					mustHit: sec.mustHitSection,
					lengthInSteps: sec.lengthInSteps,
					typeOfSection: sec.typeOfSection,
					changeBPM: {
						active: sec.changeBPM,
						bpm: sec.bpm
					},
					altAnim: sec.altAnim
				}
			);

			for (note in sec.sectionNotes)
				swagNotes.push(
					{
						noteData: note[1],
						sustainLength: note[2],
						strumTime: note[0],
						//mustHit: note[1] > 3 ? !sec.mustHitSection : sec.mustHitSection
					}
				);
		}

		return {
			song: song.song,
			bpm: song.bpm,
			speed: song.speed,
			needsVoices: song.needsVoices,
			validScore: song.validScore,
			player1: song.player1,
			player2: song.player2,
			
			notes: swagNotes,
			sections: swagSections,
			chartVersion: "1.0"
		}
	}
}
