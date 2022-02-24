function love.load()
	LUI = require "UILib"
	LUI:newObject("widget1",{y=0,wid=50,hei=50})
	LUI.setTheme("lightTheme")
end

function love.update(dt)
	LUI.update()
end

function love.draw()
	LUI.draw()
end