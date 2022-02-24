local instance = { --Inhereted by all objects
}

instance.newObject =  function(self,widgetName,properties)
	if  not properties then properties = {} end
	self.objectList[#self.objectList+1] = {objectsWidget = self.widgetList[widgetName],
	widgetList = self.widgetList,--Each object has a copy of the widgetList and the theme table
	theme = self.selectedTheme,
	properties = {}}

	if not properties.x then properties.x = 0 print "LUI: Remember to include positional values" end if not properties.y then properties.y = 0 end 
	for i,v in pairs(properties) do
		if i == "wid" then self.objectList[#self.objectList].properties["height"] = v end --Sets hei to height
		if i == "wid" then self.objectList[#self.objectList].properties["width"] = v end --sets wid to width
		self.objectList[#self.objectList].properties[i] = v 
	end


	for i,v in pairs(instance) do
		self.objectList[#self.objectList][i] = v 
	end

	return self.objectList[#self.objectList]

end



local LUI =  {

	widgetList = {},

	objectList = {},

	availableThemes = {},


	newObject = instance.newObject,

	update = function()
		local function loop(object)
			if object.objectsWidget.update then object.objectsWidget:update(object,object.properties) end
			for i,v in ipairs(object) do
				loop(v)
			end
		end

		for i,v in ipairs(LUI.objectList) do
			loop(v)
		end
	end,

	draw = function()
		local function loop(object)
			if object.objectsWidget.draw then object.objectsWidget:draw(object,object.properties) end
			for i,v in ipairs(object) do
				loop(v)
			end
		end

		for i,v in ipairs(LUI.objectList) do
			loop(v)
		end
	end,

	setTheme = function(themeName)
		if not LUI.availableThemes[themeName] then error("LUI: "..themeName.." Isn't an available theme. ") end
		LUI.selectedTheme = LUI.availableThemes[themeName]
	end


}
for i,v in ipairs(love.filesystem.getDirectoryItems(... .. "/widgetList")) do
	local wid = require ("UILib.widgetList." .. v)
	for index,widget in ipairs(wid) do
		LUI.widgetList[widget.widgetName] = widget
	end
	print(v)
end

for i,v in ipairs(love.filesystem.getDirectoryItems(... .. "/themeList")) do
	v= string.sub(v,1,-5)--Removes ".lua" extension for require
	LUI.availableThemes[v] = require (... .. ".themeList." .. v)
end

LUI.selectedTheme = LUI.availableThemes["lightTheme"]

LUI = setmetatable(LUI,{

})

return LUI