local composer = require("composer")
local scene = composer.newScene()

local physics = require ("physics")
physics.start()
physics.setGravity( 0, 0 )

local width = display.contentCenterX
local height = display.contentCenterY

local bg = display.newImage("gamebackground.jpg", width, height)
bg.rotation = 90
bg:scale(1, 1.15)

local playership = display.newImage("player.png", 400, 600)
physics.addBody(playership, "dynamic", {density = 100, friction=100, bounce=0}) 
playership.rotation = 91
playership.isFixedRotation = true -- stop spinning
playership.linearDamping = 5 -- slow down movement 

local earth = display.newImage("earth.png",width, height/0.50)
physics.addBody(earth, "dynamic",{ density = 1000000, friction=100, bounce=0  })

local enemyone = display.newImage("enemya.png", width/2, height/12)
physics.addBody(enemyone, "dynamic", { density = 10000, friction=0, bounce=0}) 
enemyone.rotation = 91

local pop = 150
earthpop=display.newText("Pop: 150", width, height/0.7, Arial,75)
earthpop:setFillColor(1,1,1)

function scene:create(event )
-- touch listener function

--add physics to object
-- add object to scene group ? local group = self.view



local function shipControl( event )
    local body = event.target
    local phase = event.phase
    local stage = display.getCurrentStage()

    if "began" == phase then
        stage:setFocus( body, event.id )
        body.isFocus = true
        body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
    elseif body.isFocus then
        if "moved" == phase then
			body.tempJoint:setTarget( event.x, event.y )
        elseif "ended" == phase or "cancelled" == phase then
            stage:setFocus( body, nil )
            body.isFocus = false
            body.tempJoint:removeSelf()    
		end
	end
    return true
	
end

local function playergun(event)

local usermissle = display.newRect(playership.x, playership.y, 10,30)
physics.addBody(usermissle, "dynamic", {density = 1, friction = 0, bounce =0.1}) 
usermissle:applyForce( 0, -1000,  usermissle.x, usermissle.y)

local function killmiss( event )
	usermissle:removeSelf ()
end

timer.performWithDelay( 500, killmiss )

end

local function roundtran (event)
transition.to( enemyone, {time =2500, x=width-250, transition=easing.linear,  onComplete = backto } )
 
 function backto (event)
transition.to( enemyone, {time = 2500, x=width+250, transition=easing.linear, onComplete=roundtran} )
end

end


local function enemygun(event)


local enemymiss = display.newRect(enemyone.x+45, enemyone.y+45, 10,30)
enemymiss:setFillColor(1,0,0)
physics.addBody(enemymiss, "dynamic", {density = 1, friction = 0, bounce =0.1}) 
enemymiss:applyForce( 0, 500,  enemymiss.x, enemymiss.y)

local function killmiss( event )
	enemymiss:removeSelf ()
end

timer.performWithDelay( 2000, killmiss )

end

local function score( event )
	pop = pop -1
	earthpop.text=("Pop: "..pop)
	return true
	end

local backgroundmusic = audio.loadStream( "starmusic.mp3 "  )
audio.play(backgroundmusic)

timer.performWithDelay(1000, enemygun, 0)
-- actual place for listeners during gameplay

earth:addEventListener("collision",score)
playership:addEventListener("touch",roundtran)
bg:addEventListener("tap", playergun)
playership:addEventListener( "touch", shipControl )		

end


function scene:hide( event )
    if ( event.phase == "will" ) then
        bg:removeSelf()
        bg = nil
       
        blueButton:removeEventListener( "tap", goBlue )
        blueButton:removeSelf()
        blueButton = nil
       
        greenButton:removeEventListener( "tap", goGreen )
        greenButton:removeSelf()
        greenButton = nil
       
        --composer.removeScene( "redScene" )
    end
end

-- listener for scene's
scene:addEventListener( "create", scene )
--scene:addEventListener( "hide", scene )



return scene -- needed to let main know scene loaded