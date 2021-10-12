local tab= {}



function tab.newFrame(self,xPos,yPos,Wid,Hei,Mis)
	if Mis == nil then Mis = {} end
  
	self.Frames[#self.Frames+1] = {Type="Frame",Enabled=true,X=xPos,Y=yPos,Wid=Wid,Hei=Hei,
	BGColour=Mis.BGColour,BGImage=Mis.BGImage,frameClipping=Mis.frameClipping,RX=Mis.RX,RY=Mis.RY,Segments = Mis.Segments,
	scrollwheelY=0,scrollwheelX=0--[[On a normal frame scrollwheelPos is a constant 0]],Frames={},Contents={},
  
	newLabel = LUID.newLabel,
	newTextBox=LUID.newTextBox,
	newButton = LUID.newButton,
	newFrame=LUID.newFrame,
  
	Stencil=function()
	  love.graphics.rectangle("fill",xPos,yPos,Wid,Hei,Mis.RX,Mis.RY,Mis.Segments)
	end,}
  
	return self.Frames[#self.Frames]
  end


  