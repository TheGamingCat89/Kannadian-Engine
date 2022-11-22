var PlayState = require("PlayState");
var Std = require("Std");
var StringTools = require("StringTools");

var followchars = true;

var xx = 520;
var yy = 540;
var xx2 = 820;
var yy2 = 540;
var ofs = 19;

var del = 0;
var del2 = 0;

function update(elapsed:Float)
{
	if (del > 0)
		del -= 1;

	if (del2 > 0)
		del2 -= 1;
	
    if (followchars)
    {
        if (!PlayState.SONG.sections[Std.int(PlayState.instance.curStep / 16)].mustHit)
        {
            if (PlayState.instance.dad.animation.curAnim.name.startsWith('singLEFT'))
                PlayState.instance.camFollow.setPosition(xx-ofs,yy);
            
            if (PlayState.instance.dad.animation.curAnim.name.startsWith('singRIGHT'))
                PlayState.instance.camFollow.setPosition(xx+ofs,yy);
            
            if (PlayState.instance.dad.animation.curAnim.name.startsWith('singUP'))
                PlayState.instance.camFollow.setPosition(xx,yy-ofs);
            
            if (PlayState.instance.dad.animation.curAnim.name.startsWith('singDOWN'))
                PlayState.instance.camFollow.setPosition(xx,yy+ofs);
            
            if (PlayState.instance.dad.animation.curAnim.name.startsWith('idle'))
                PlayState.instance.camFollow.setPosition(xx,yy);
        }
        else
        {
            if (PlayState.instance.boyfriend.animation.curAnim.name == 'singLEFT')
                PlayState.instance.camFollow.setPosition(xx2-ofs,yy2);
            
            if (PlayState.instance.boyfriend.animation.curAnim.name == 'singRIGHT')
                PlayState.instance.camFollow.setPosition(xx2+ofs,yy2);
            
            if (PlayState.instance.boyfriend.animation.curAnim.name == 'singUP')
                PlayState.instance.camFollow.setPosition(xx2,yy2-ofs);
            
            if (PlayState.instance.boyfriend.animation.curAnim.name == 'singDOWN')
                PlayState.instance.camFollow.setPosition(xx2,yy2+ofs);
            
	        if (PlayState.instance.boyfriend.animation.curAnim.name == 'idle')
                PlayState.instance.camFollow.setPosition(xx2,yy2);
            
        }
    }

    /*[
        17789.1599925498,
        -1,
        "Add Camera Zoom",
        "0.03",
        "0"
    ],
    [
        17916.2786366176,
        -1,
        "Add Camera Zoom",
        "0.03",
        "0"
    ],
    [
        18043.3972806854,
        -1,
        "Add Camera Zoom",
        "0.03",
        "0"
    ],
    [
        18170.5159247532,
        -1,
        "Add Camera Zoom",
        "0.03",
        "0"
    ]*/
}