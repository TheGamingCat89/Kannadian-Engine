import openfl.utils.ByteArray;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;

class Visualizer extends FlxState {

    var sound:Sound;
    var channel:SoundChannel;

    override public function create()
    {
      super.create();

      // load the audio file
      sound = Assets.getSound("audio.mp3");

      // play the audio
      channel = sound.play();

      // listen for the "complete" event
      channel.addEventListener(Event.SOUND_COMPLETE, onComplete);

      // create a sprite for the visualizer
      var sprite = new FlxSprite(100,100);
      add(sprite);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var bytes = new ByteArray();
        SoundMixer.computeSpectrum(bytes, true);

        sprite.graphics.clear();
        sprite.graphics.lineStyle(1, 0xFF0000);
        sprite.graphics.drawCircle(0, 0, bytes.readFloat() * 50);
    }

    function onComplete(event:Event) {
        // reset the audio and start over
        channel.stop();
        channel = sound.play();
    }

}
