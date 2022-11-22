//packaging isnt supported

//THIS IS AN EXAMPLE SCRIPT
//ALL THE EXISTING FUNCTIONS WILL BE HERE JUST TO SHOW IT OR SOMETHING

//you can use require !!!!
//hscript doesnt support import   yet
//this is just used to get classes, you cannot read files with this
var Json = require("haxe.Json");

//finals arent supported
//public and private modifiers arent supported
//no static, macro, extern, nor overload

//type declarations are ignored by parser anymore
var hi = "final variable";
var test:Bool = 1;

//you cannot make classes    yet

//you cannot define enums nor abstracts
//they arent supported   yet

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