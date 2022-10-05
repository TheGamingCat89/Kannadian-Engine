//THIS IS AN EXAMPLE SCRIPT
//ALL THE EXISTING FUNCTIONS WILL BE HERE JUST TO SHOW IT OR SOMETHING
//scroll all the way down to see all the imported classes!!

function create()
{
    //runs at start of create
}

function createPost()
{
    //runs and the end of create
}

function startCountdown()
{
    //runs when the countdown started
}

function countdown(swagCounter)
{
    //runs each time the countdown goes down
}

function startSong()
{
    //runs when the song starts duh
}

function generateSong()
{
    //runs when the notes and music are generated
}

function onFocus()
{
    //runs when you focus on the window
}

function onFocusLost()
{
    //runs when you lose focus on your window
}

function update(elapsed)
{
    //runs at the start of every frame
}

function updatePost(elapsed)
{
    //runs at the end of every frame
}

function endSong()
{
    //runs when the song ends of course,
}

function destroy()
{
    //runs when you exit playstate
}

function keyPress(event)
{
    //runs every time you press a key, using keyboardevent
}

function keyRelease(event)
{
    //runs every time you release a key, using keyboardevent
}

function noteMiss(direction)
{
    //runs every time you miss a note
}

function goodNoteHit(note)
{
    //runs every time you hit a note doesnt matter the rating
}

function opponentNoteHit(note)
{
    //runs every time the opponent hits a note
}

function stepHit()
{
    //runs every step
}

function beatHit()
{
    //runs every beat
}

//ok so this was changed so ummmm
//require is now a thing, it returns the class
var Json =  require("haxe.Json");
//if u used javascript u should know what this means
//but its basically an import, u gotta assign it to a variable
//this doesnt exactly work like js require, just an importing of classes
//alternatively you can use actual import, which now works
import haxe.Json;