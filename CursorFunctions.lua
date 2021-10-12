--[[MIT License
Copyright (c) 2021 Ballance100
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]






local CursorFunctions = {}
local DoScale = false
gameWidth,gameHeight = 0,0
local JoyStick = true

function dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function CursorFunctions.Settings(Scale,fgameWidth,fgameHeight,JoyStickEnabled)
	DoScale = Scale
	gameWidth,gameHeight = fgameWidth,fgameHeight
	JoyStick = JoyStickEnabled
end
--[[love.graphics.scale() and the push library don't
	scale mouse position causing issues.The WindowScale func scales the mousePosition
	according to the windowScale. This can be turned off by calling CursorFunctions.settings and
	setting the first argument(Scale) to false
--]]

function CursorFunctions.WindowScale()
WindowXWidth,WindowYWidth = love.window.getMode()
local xScale,yScale = gameWidth/WindowXWidth,gameHeight/WindowYWidth
return xScale,yScale
end

function CursorFunctions.IsHovering(objX,objY,objWid,objHei)--Checks if the users mouse is on the CursorFunctions
	local MouseX,MouseY = love.mouse.getPosition()
	if DoScale == true then
		xScale,yScale = CursorFunctions.WindowScale()
		MouseX,MouseY = MouseX*xScale,MouseY*yScale
	end
	if objHei ~= nil then --Checks if the last argument was passed. If it was then it checks area of a square/rectangle. If it wasnt passed then it checks for radius
		objWidEnd = objX +objWid--Object Width End(top right corner)
		objHeiEnd = objY + objHei--Object Height End(bottom left corner)
		if MouseX >= objX and MouseX <= objWidEnd and MouseY >= objY and MouseY <= objHeiEnd then
			return true
		else return false
		end
	elseif objHei == nil then
		ObjXStart,ObjXEnd = objX -objWid,objX+objWid
		ObjYStart,ObjYEnd = objY - objWid,objY+objWid
		if dist(MouseX,MouseY, objX,objY) <= objWid then
			return true
		else return false
		end
		end
	end

	function CursorFunctions.UpdateCursor()
		local MouseX,MouseY = love.mouse.getPosition()
		if JoyStick == true then
			NumofG = love.joystick.getJoystickCount()
			if NumofG >= 1 then
				Gamepad1 = love.joystick.getJoysticks()[1]
				Dir1,Dir2,PH,Dir3,Dir4 = Gamepad1:getAxes()
				local moveX,moveY = MouseX + Dir1*2.5,MouseY+Dir2*3.5
				love.mouse.setPosition(moveX,moveY)

			end
		end
	end

function CursorFunctions.clickedAnywhere(Button)--Button:1 is left click/mobile tap. Button: 2 is right click/touch held
	if love.mouse.isDown(Button) then
		return true
	end

end



function CursorFunctions.IsClicked(type,objX,objY,objWid,objHei)
	if love.mouse.isDown(type) then
		local MouseX,MouseY = love.mouse.getPosition()
		if DoScale == true then
		xScale,yScale = CursorFunctions.WindowScale()
		MouseX,MouseY = MouseX*xScale,MouseY*yScale
		end
		if objHei ~= nil then --Checks if the last argument was passed. If it was then it checks area of a square/rectangle. If it wasnt passed then it checks for radius
		objWidEnd = objX +objWid--Object Width End(top right corner)
		objHeiEnd = objY + objHei--Object Height End(bottom left corner)
			if MouseX >= objX and MouseX <= objWidEnd and MouseY >= objY and MouseY <= objHeiEnd then
				return true
			else return false
			end
		elseif objHei == nil then
			ObjXStart,ObjXEnd = objX -objWid,objX+objWid
			ObjYStart,ObjYEnd = objY - objWid,objY+objWid
			if dist(MouseX,MouseY, objX,objY) <= objWid then
				return true
				else return false
			end
		end
	else return false
	end
		end

return CursorFunctions
