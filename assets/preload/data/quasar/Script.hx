var PlayState = require("PlayState");
var Math = require("Math");

var sineShit = 0;
function update(elapsed)
{
    sineShit += elapsed;
    PlayState.instance.playerStrums.forEach(function(strum)
    {
        strum.x += Math.sin(sineShit) * 500;
    });
}