package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class Test extends Sprite
{
    public function new() {
        super();

        addChild(new Bitmap(Assets.getBitmapData(Paths.image("preloaderArt"))));
        
    }
}