local widget = require( "widget" ) 

local composer = require("composer" ) -- lib
local scene = composer.newScene() --new scene dec


local help, start, sound, startT, helpT, soundT, bg, xpos, ypos

function scene:create( event )

local sceneGroup = self.view
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc
	
xpos=display.contentCenterX
ypos=display.contentCenterY

bg = display.newImage("backdrop.jpg", xpos, ypos)
bg.rotation = 90
bg:scale(1, 1.2)

start= display.newCircle( 100, 250, 30)--start 01
start:setFillColor(0,1,0)
--sceneGroup:insert(start)

help= display.newCircle( 100, 500, 30)--help 02
--sceneGroup:insert(help)
start:setFillColor(0,1,0)

sound= display.newCircle( 100, 750, 30) --sound 03
--sceneGroup:insert(sound)
start:setFillColor(0,1,0)

startT = display.newText( "Start", 100, 250, "Helvetica", 18 ) -- 01
startT:setTextColor( 0, 0, 0 )
startT.rotation = 90
--sceneGroup:insert(startT)

helpT = display.newText( "Help", 100, 500, "Helvetica", 18, bold )-- 02
helpT:setTextColor( 0, 0, 0 )
helpT.rotation = 90
--sceneGroup:insert(helpT)

soundT = display.newText( "Sound", 100, 750, native.systemFontBold, 18 ) --03
soundT:setTextColor( 0, 0, 0, 255 )
soundT.rotation = 90
--sceneGroup:insert(soundT)


function startgame (event)
composer.gotoScene( "game", { effect = "fade", time = 300 } )
end

startT:addEventListener("tap", startgame)

end


function scene:hide( event )
    if ( event.phase == "will" ) then
        bg:removeSelf()
        composer.removeScene( "start" )
    end
end
---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene ) -- lets scene get loaded
scene:addEventListener( "show", scene ) -- holds vars and functions for this scene
scene:addEventListener( "hide", scene ) -- distroy scene objects and scene itself
---------------------------------------------------------------------------------
return scene