return {
	{

		widgetName = "widget1",
		update = function(self,object,properties)
			
		end,

		draw = function (self,object,properties)
			local theme = object.theme
			local p = properties
			love.graphics.rectangle("fill",p.x,p.y,p.width,p.height)
		end
	}
}