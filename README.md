# G910xmit
World of Warcraft AddOn code for use with WoW G910 application

Download the application for macOS or Windows at www.jdsoftcode.net.

## Description
This WoW addon registers for notification of a collection of in-game events using the standard Blizzard API for event monitoring. When notified of an event by the game, it recordes it in a queue.

That queue is checked every 0.2 seconds, plus or minus the frame rate of the game. If a message is queued, it "transmits" the message by changing textures in a small frame located at the top-left corner of the game window. The texture pattern always represents a 7-bit ASCII character (black = 0, color = 1). There are also 2 extra "bits" on either side of the character's 7 bits used to calibrate to the pattern's position on screen and to signify the transmission of each character.

Most of the code is concerned with monitoring the status of the action bar slots and queuing messages about those slots going ready or onto cooldown.
