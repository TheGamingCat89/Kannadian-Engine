import PlayState;
import Math;

var sine = 0.0;

function update(elapsed)
{
    sine += elapsed;
    var i = 0;
    PlayState.instance.strums.forEach((strum) ->
    { 
        strum.y = PlayState.instance.strumLine.y + 100 * Math.sin(sine * ((i + 1)));
        i++;
    });
}