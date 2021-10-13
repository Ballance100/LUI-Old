

local LUI = {Frames={},Settings={scaleX,scaleY},selectedTextBox=nil}

local scaleX,scaleY

local LUID = {}--LUI Dev. functions only to be used in this script. used to save code

local CurFun = require("LUI.CursorFunctions")

local Timer = require("LUI.timer")

local Flux = require("LUI.Flux")

local utf8 = require("utf8")



ICursor = love.mouse.getSystemCursor("ibeam")--Hovering over text curosr
Mouse = love.mouse.getSystemCursor("arrow")--Default cursor
SelectCursor = love.mouse.getSystemCursor("hand")--Hovering over button cursor


function LUI:Setup(fdoScale,fdoSizeScale,fgameWidth,fgameHeight)--do scale only scales Position and click detection.
  --Only set this to true if youre using a scale library such as push or are scaling your game manually
  --fdoSizeScale scales the size of ui elements not the positions
  doScale,doSizeScale,gameWidth,gameHeight = fdoScale,fdoSizeScale,fgameWidth,fgameHeight
  CurFun.Settings(fdoScale,fgameWidth,fgameHeight,false)
  self.Settings.canRun = true
end



function LUID:isClicked(Num)--Num is the mouse button
  if Num == nil then Num = 1 end
  return CurFun.IsClicked(Num,self.X,self.Y,self.Wid,self.Hei)
end



function LUID:isHovering()
  return CurFun.IsHovering(self.X,self.Y,self.Wid,self.Hei)
end

function LUID:tweenProperties(Time,Items)
  Flux.to(self,Time,Items)
end


function LUID:newLabel(X,Y,Wid,Hei,Mis)
  if Mis == nil then Mis = {} end
  if Mis.Fill == nil then Mis.Fill = "fill" end
  if Mis.textOffset == nil then Mis.textOffset = {0,0} end

  self.Contents[#self.Contents+1] = {Type="Label",Enabled=true,X=X+self.X,Y=Y+self.Y,Wid=Wid,Hei=Hei,
  Text=Mis.Text, textColour=Mis.textColour,textOffset=Mis.textOffset,Font=Mis.Font,CenterText=Mis.CenterText,
  BGColour=Mis.BGColour,BGImage=Mis.BGImage,FClipping=Mis.frameClipping,Fill=Mis.Fill,

  isHovering = LUID.isHovering,

    }

  return self.Contents[#self.Contents]
end

function LUID:newButton(X,Y,Wid,Hei,Mis)
  if Mis == nil then Mis = {} end
  if Mis.Fill == nil then Mis.Fill = "fill" end
  if Mis.textColour == nil then Mis.textColour = {1,1,1,1} end
  if Mis.Text == nil then Mis.Text = "" end
  if Mis.textAlign == nil then Mis.textAlign = "left" end

  self.Contents[#self.Contents+1] = {Type="Button",Enabled=true,X=X+self.X,Y=Y+self.Y,Wid=Wid,Hei=Hei,
  Text=Mis.Text, Font=Mis.Font,textAlign=Mis.textAlign,
  BGColour=Mis.BGColour,BGImage=Mis.BGImage,hoveringBGImage=Mis.hoveringBGImage,clickedBGImage=Mis.clickedBGImage,
  BFClipping=Mis.frameClipping,Fill=Mis.Fill,
  RY=Mis.RX,RX=Mis.RX,Segments=Mis.Segments,

  textColour=Mis.textColour,


  isClicked = LUID.isClicked,
  isHovering = LUID.isHovering,

    }

  return self.Contents[#self.Contents]
end

function LUID:newTextBox(X,Y,Wid,Font,Mis)
  if Mis == nil then Mis = {} end
  if Mis.Fill == nil then Mis.Fill = "fill" end
  if Mis.textColour == nil then Mis.textColour = {1,1,1,1} end
  if Mis.cursorColour == nil then Mis.cursorColour = {1,1,1,1} end
  if Mis.cursorBlinkSpeed == nil then Mis.cursorBlinkSpeed = .5 end
  if Mis.cursorColour[4] == nil then Mis.cursorColour[4] = 1 end
  if Mis.Text == nil then Mis.Text = "" end
  if Mis.textAlign == nil then Mis.textAlign = "left" end

  self.Contents[#self.Contents+1] = {Type="textBox",Enabled=true,X=X+self.X,Y=Y+self.Y,Wid=Wid,Hei=Font:getHeight(),
  Text=Mis.Text, Font=Font,textAlign=Mis.textAlign,BGColour=Mis.BGColour,FClipping=Mis.frameClipping,Fill=Mis.Fill,
  RY=Mis.RX,RX=Mis.RX,Segments=Mis.Segments,

  CurHeight=0,smoothCursor=Mis.smoothCursor,textColour=Mis.textColour,cursorBlinkSpeed=Mis.cursorBlinkSpeed,
  cursorColour = Mis.cursorColour,CX=Font:getWidth(Mis.Text)--[[Cursor X Pos]],CurTextPos=0,


  isClicked = LUID.isClicked,
  isHovering = LUID.isHovering,

    }

  return self.Contents[#self.Contents]
end


function LUI:newFrame(xPos,yPos,Wid,Hei,Mis)--Neccasary to have this to allow frames inside of frames
  return LUID.newFrame(self,xPos,yPos,Wid,Hei,Mis)
end

function LUI:newScrollableFrame(xPos,yPos,Wid,Hei,Mis)--Same with this
  return LUID.newScrollableFrame(self,xPos,yPos,Wid,Hei,Mis)
end


function LUID:newFrame(xPos,yPos,Wid,Hei,Mis)
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



function LUID:newScrollableFrame(xPos,yPos,Wid,Hei,Mis)
  if Mis == nil then Mis = {} end
  if Mis.scrollwheelDimensions == nil then Mis.scrollwheelDimensions = {Wid=40,Hei=40} end
  if Mis.scrollwheelColour == nil then Mis.scrollwheelColour = {.1,.1,.1} end
  if Mis.scrollwheelHoveringColour == nil then Mis.scrollwheelHoveringColour = Mis.scrollwheelColour end     
  if Mis.scrollWheelSelectedColour ==  nil then Mis.scrollWheelSelectedColour = Mis.scrollwheelHoveringColour end
  if Mis.scrollwheelOffset == nil then Mis.scrollwheelOffset = {0,0} end

  self.Frames[#self.Frames+1] = {Type="scrollableFrame",Enabled=true,X=xPos,Y=yPos,Wid=Wid,Hei=Hei,
  BGColour=Mis.BGColour,BGImage=Mis.BGImage,frameClipping=true,RX=Mis.RX,RY=Mis.RY,Segemts=Mis.Segments,--frameClipping is always true on a scrollable frame
  scrollwheelColour = Mis.scrollwheelColour,  scrollwheelHoveringColour = Mis.scrollwheelHoveringColour,
  scrollwheelSelectedColour=Mis.scrollwheelSelectedColour   ,scrollwheelImage=Mis.scrollwheelImage,
  SWRX = Mis.SWRX,SWRY = Mis.SWRY,scrollwheelOffset = Mis.scrollwheelOffset,--Edge radius of scroll wheel rectangle
  xContent=0,yContent=0,--Refers to how much the scroll wheel should scale
  scrollwheelDimensions=Mis.scrollwheelDimensions,scrollwheelX=0,scrollwheelY=0,
  isHoldingYScroll = false,isHoldingXScroll=false,--Is holding scroll wheel. Means that user can move their cursor more freely when scroling
   Frames={},Contents={},

  newLabel = LUID.newLabel,
  newTextBox=LUID.newTextBox,
  newButton = LUID.newButton,
  newFrame=LUID.newFrame,

  Stencil=function()
    love.graphics.rectangle("fill",xPos,yPos,Wid,Hei,Mis.RX,Mis.RY,Mis.Segments)
  end,}


  return self.Frames[#self.Frames]
end




function LUI:Update(dt)
  stbFading = true
  Timer.update(dt)
  Flux.update(dt)
  if doScale == true then
    scaleX,scaleY = love.graphics.getWidth()/gameWidth,love.graphics.getHeight()/gameHeight
  else scaleX,scaleY = 1,1

  end

  if doSizeScale == true then sizeScaleX,sizeScaleY = love.graphics.getWidth()/gameWidth,love.graphics.getHeight()/gameHeight
  else sizeScaleX,sizeScaleY = 1,1 end


--Selected Text Box
  if LUI.selectedTextBox ~= nil then 

    CR,CG,CB = LUI.selectedTextBox.cursorColour[1],LUI.selectedTextBox.cursorColour[2],LUI.selectedTextBox.cursorColour[3]

    if LUI.selectedTextBox.cursorColour[4] >= 1 then
      LUI.selectedTextBox.cursorColour[4] = 1
      timer = Flux.to(LUI.selectedTextBox.cursorColour,LUI.selectedTextBox.cursorBlinkSpeed,{CR,CG,CB, 0 }):ease("quartin")

    elseif LUI.selectedTextBox.cursorColour[4] <= 0 then
      LUI.selectedTextBox.cursorColour[4] = 0
      timer2 = Flux.to(LUI.selectedTextBox.cursorColour,LUI.selectedTextBox.cursorBlinkSpeed,{CR,CG,CB,1}):ease("quartout")
    end

    if LUI.selectedTextBox.smoothCursor == true then
      Flux.to(LUI.selectedTextBox,.1,{CX=LUI.selectedTextBox.Font:getWidth(LUI.selectedTextBox.Text:sub(1,LUI.selectedTextBox.CurTextPos))})
    else LUI.selectedTextBox.CX = LUI.selectedTextBox.Font:getWidth(LUI.selectedTextBox.Text:sub(1,LUI.selectedTextBox.CurTextPos))
    end
  end



  local function updateFrames(Index,Frame)
    local xCount = 0--Used to tell how much stuff is in a scrollable Frame
    local yCount = 0
    local CurPosPrevX,curPosPrevY = 0,0
      for k,y in ipairs(Frame.Contents) do

        if y.X+y.Wid >= xCount then xCount = y.X+y.Wid-Frame.X end
        if y.Y+y.Hei >= yCount then yCount = y.Y+y.Hei-Frame.Y end

      

        if y.Type == "textBox" then
          if CurFun.IsHovering(y.X,y.Y,y.Wid,y.Hei) then
            love.mouse.setCursor(ICursor)
          end

          if CurFun.IsClicked(1,y.X,y.Y,y.Wid,y.Hei) then
            local xCurPos = love.mouse.getX()-y.X
            y.CurTextPos = y.Wid/y.Font:getWidth(1)
            if y.smoothCursor == true and LUI.selectedTextBox ~= y then Timer.tween(.25,y,{CurHeight=y.Font:getHeight()},"in-quad")
            elseif y.smoothCursor == false then y.CurHeight = y.Font:getHeight() end
            LUI.selectedTextBox = y
          end
        end
      end
      if Frame.Type == "scrollableFrame" then 
        local Height = Frame.Hei*Frame.Hei/Frame.yContent
          local yCon = Frame.Hei/Frame.yContent
          local xCon = Frame.Wid*Frame.Wid/Frame.xContent
          if Frame.Y+Height-Frame.scrollwheelY*yCon > Frame.Y+Frame.Hei then Frame.scrollwheelY = -Frame.yContent+Frame.Hei end
        

          --Scrolling
          if Frame.isHoldingYScroll == true then

          if CurFun.clickedAnywhere(1) then
            local mouse_diff = prevCurPosY - curCurPosY
            Frame.scrollwheelY =  mouse_diff/yCon
            
            if Frame.Y+Height-Frame.scrollwheelY*yCon > Frame.Y+Frame.Hei then Frame.scrollwheelY = -Frame.yContent+Frame.Hei 
            elseif Frame.Y-Frame.scrollwheelY*yCon < Frame.Y then Frame.scrollwheelY = 0 end
          else Frame.isHoldingYScroll = false
            end
          end



          print(Frame.isHoldingXScroll)
        if Frame.isHoldingXScroll == true then
          if CurFun.clickedAnywhere(1) then
            local mouse_diff = prevCurPosX - curCurPosX
            Frame.scrollwheelY =  mouse_diff/xCon
            if Frame.X+Height-Frame.scrollwheelX*xCon > Frame.X+Frame.Wid then Frame.scrollwheelX = -Frame.xContent+Frame.Wid 
            elseif Frame.x-Frame.scrollwheelY*xCon < Frame.X then Frame.scrollwheelX = 0 end
          else Frame.isHoldingXScroll = false
          end          

        end



        Frame.xContent = xCount Frame.yContent = yCount 
        curCurPosX,curCurPosY = love.mouse.getPosition()

  
        if CurFun.IsClicked(1,Frame.X+Frame.Wid-Frame.scrollwheelDimensions.Wid+Frame.scrollwheelOffset[2],
        Frame.Y-Frame.scrollwheelY*yCon,
        Frame.scrollwheelDimensions.Wid,
        Frame.Hei*Frame.Hei/Frame.yContent) and  Frame.isHoldingYScroll == false then
          Frame.isHoldingYScroll = true
          prevCurPosX,prevCurPosY = love.mouse.getPosition()
          if Frame.scrollwheelY ~= nil then prevCurPosY = prevCurPosY+Frame.scrollwheelY*yCon end





          if CurFun.IsClicked(1,Frame.X+Frame.scrollwheelOffset[2]-Frame.scrollwheelX*xCon,
          Frame.Y+Frame.Hei-Frame.scrollwheelDimensions.Hei+Frame.scrollwheelOffset[2],
          Frame.Wid*Frame.Wid/Frame.xContent,
          Frame.scrollwheelDimensions.Hei) and  Frame.isHoldingXScroll == false then

            Frame.isHoldingXScroll = true
            prevCurPosX,prevCurPosY = love.mouse.getPosition()
             --prevCurPosX = prevCurPosX+Frame.scrollwheelX*xCon
          end
        end
      end
  end

  local function findFrames(Frame)
    for i,v in ipairs(Frame.Frames) do
      updateFrames(i,v)
      findFrames(v)
    end
  end
  findFrames(LUI)


end





function LUI:Draw()
  assert(self.Settings.canRun,"You need to setup first")

  --Frames
  function drawFrames(Index,Frame)
    PR,PG,PB,PA = love.graphics.getColor()
  

      if Frame.BGColour ~= nil then
        PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
        love.graphics.setColor(Frame.BGColour)
      end

      if Frame.BGImage ~= nil then
        love.graphics.draw(Frame.BGImage,Frame.X,Frame.Y)
      else love.graphics.rectangle("fill",Frame.X*scaleX,Frame.Y*scaleY,Frame.Wid*sizeScaleX,Frame.Hei*sizeScaleY,Frame.RX,Frame.RY,Frame.Segments) end
      if Frame.BGColour ~= nil then love.graphics.setColor(PR,PG,PB,PA) end


      --UI elements
        for k,y in ipairs(Frame.Contents) do
          local PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
          if Frame.frameClipping == true then
            love.graphics.stencil(Frame.Stencil,"replace",1)
            love.graphics.setStencilTest("greater",0)
          end
          --Label
          if y.Type == "Label" then

            if y.BGColour ~= nil then
              PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
              love.graphics.setColor(y.BGColour)
            end

            if y.BGImage ~= nil then
              love.graphics.draw(y.BGImage,y.X+Frame.scrollwheelX,y.Y+Frame.scrollwheelY,0,
              y.Wid/y.BGImage:getWidth(),y.Hei/y.BGImage:getHeight())
            else
            love.graphics.rectangle(y.Fill,y.X+Frame.scrollwheelX*sizeScaleX,y.Y+Frame.scrollwheelY*sizeScaleY,y.Wid*sizeScaleX,y.Hei*sizeScaleY,y.RX,y.RY,y.Segments)
            end
            if y.BGColour ~= nil then love.graphics.setColor(PR,PG,PB,PA) end

            if y.Font ~= nil then 
              love.graphics.setColor(y.textColour)
              local Text = love.graphics.newText(y.Font,y.Text)
              love.graphics.draw(Text,y.X*sizeScaleX+y.textOffset[1]*sizeScaleX,y.Y*sizeScaleY+y.textOffset[2]*sizeScaleY,0,sizeScaleX,sizeScaleY)
            end
          --TextBox
          elseif y.Type == "Button" then
            if y.BGColour ~= nil then
              PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
              love.graphics.setColor(y.BGColour)
            end

            if y.BGImage ~= nil then
              love.graphics.draw(y.BGImage,y.X,y.Y,0,y.Wid/y.BGImage:getWidth(),y.Hei/y.BGImage:getHeight())
            else
            love.graphics.rectangle(y.Fill,y.X,y.Y,y.Wid,y.Hei,y.RX,y.RY,y.Segments)
            end
            if y.BGColour ~= nil then love.graphics.setColor(PR,PG,PB,PA) end

          elseif y.Type == "textBox" then


            --Drawing background box
            if y.BGColour ~= nil then
              PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
              love.graphics.setColor(y.BGColour)
            end

            --Still drawing background box
            love.graphics.rectangle("line",y.X*sizeScaleX,y.Y*sizeScaleY,y.Wid*sizeScaleX,y.Font:getHeight(),y.RX,y.RY,y.Segments )
            love.graphics.setColor(PR,PG,PB,PA)


            --Drawing Cursor
            local l = love.graphics.getLineWidth()
            PR,PG,PB,PA = love.graphics.getColor()--Previous Blue,Red,Green and alpha
            love.graphics.setColor(y.cursorColour)

            if LUI.selectedTextBox == y then
            love.graphics.setLineStyle("smooth")
            love.graphics.setLineWidth(2.5)
            love.graphics.line(y.X*sizeScaleX+y.CX,y.Y*sizeScaleY+y.Font:getHeight()-2,y.X*sizeScaleX+y.CX,y.Y*sizeScaleY+y.Font:getHeight()-y.CurHeight+2)
            love.graphics.setLineWidth(l)
            love.graphics.setColor(PR,PG,PB,PA)
            end

            
            --Drawing Text
            local function TextStencil()
              love.graphics.rectangle("fill",y.X,y.Y,y.Wid,y.Hei,y.RX,y.RY,y.Segemnts)
            end
            love.graphics.stencil(TextStencil,"replace",1)
            love.graphics.setStencilTest("greater",0)
            love.graphics.setColor(y.textColour)

            local Text = love.graphics.newText(y.Font,y.Text)
            love.graphics.draw(Text,y.X*sizeScaleX,y.Y*sizeScaleY)

            love.graphics.setColor(PR,PG,PB,PA)
            love.graphics.setStencilTest()
          end
        end


        if Frame.Type == "scrollableFrame" then
          local xCon = Frame.Wid/Frame.xContent
          local yCon = Frame.Hei/Frame.yContent--percentage of frame covered divided by 100.IE 100 percent would be 1

          if Frame.isHoldingYScroll==true then
          love.graphics.setColor(Frame.scrollwheelSelectedColour)
          elseif CurFun.IsHovering(Frame.X+Frame.Wid-Frame.scrollwheelDimensions.Wid+Frame.scrollwheelOffset[2],
          Frame.Y+Frame.scrollwheelOffset[2]-Frame.scrollwheelY*yCon,
          Frame.scrollwheelDimensions.Wid,
          Frame.Hei*Frame.Hei/Frame.yContent) then
              love.graphics.setColor(Frame.scrollwheelHoveringColour)
            else love.graphics.setColor(Frame.scrollwheelColour)
          end
  
  
        --Right hand side Y-Axis scrollbar
          if Frame.Hei*Frame.Hei/Frame.yContent < Frame.Hei then--Should be less than 1 not Frame.Hei
            love.graphics.rectangle("fill",
            Frame.X+Frame.Wid-Frame.scrollwheelDimensions.Wid+Frame.scrollwheelOffset[2],
            Frame.Y+Frame.scrollwheelOffset[2]-Frame.scrollwheelY*yCon,
            Frame.scrollwheelDimensions.Wid,
            Frame.Hei*Frame.Hei/Frame.yContent,
            Frame.SWRX,--Scroll wheel edge radius(X)
            Frame.SWRY
            )
         
          end


          if Frame.isHoldingXScroll==true then
          love.graphics.setColor(Frame.scrollwheelSelectedColour)
          elseif CurFun.IsHovering(Frame.X+Frame.scrollwheelOffset[2]-Frame.scrollwheelX*xCon,
          Frame.Y+Frame.Hei-Frame.scrollwheelDimensions.Hei+Frame.scrollwheelOffset[2],
          Frame.Wid*Frame.Wid/Frame.xContent,
          Frame.scrollwheelDimensions.Hei) then
              love.graphics.setColor(Frame.scrollwheelHoveringColour)
            else love.graphics.setColor(Frame.scrollwheelColour)
          end
    

          --Bottom X-axis scrollbar
          love.graphics.rectangle("fill",
          Frame.X+Frame.scrollwheelOffset[2]-Frame.scrollwheelX*xCon,
          Frame.Y+Frame.Hei-Frame.scrollwheelDimensions.Hei+Frame.scrollwheelOffset[2],
          Frame.Wid*Frame.Wid/Frame.xContent,
          Frame.scrollwheelDimensions.Hei,
          Frame.SWRX,
          Frame.SWRY)

        end
    love.graphics.setStencilTest()
    love.graphics.setColor(PR,PG,PB,PA)

  end



  local function findFrames(Frames)
    for i,v in ipairs(Frames.Frames) do
      drawFrames(i,v)
      findFrames(v)
    end

  end
  findFrames(LUI)
end



function LUI.keypressed(Key)
  if LUI.selectedTextBox ~= nil then
    if Key == "backspace" then
      if LUI.selectedTextBox.CurTextPos >= 1 then
        local str1 = LUI.selectedTextBox.Text:sub(1,LUI.selectedTextBox.CurTextPos-1)
        local str2 = LUI.selectedTextBox.Text:sub(LUI.selectedTextBox.CurTextPos+1,-1)
        LUI.selectedTextBox.Text = str1..str2

       LUI.selectedTextBox.CurTextPos = LUI.selectedTextBox.CurTextPos -1
      end
    elseif Key == "left" then
     LUI.selectedTextBox.CurTextPos = LUI.selectedTextBox.CurTextPos -1
    elseif Key == "right" then
      LUI.selectedTextBox.CurTextPos = LUI.selectedTextBox.CurTextPos +1
    end
    if LUI.selectedTextBox.CurTextPos < 0 then LUI.selectedTextBox.CurTextPos = 0 end
    if LUI.selectedTextBox.CurTextPos > LUI.selectedTextBox.Text:len() then LUI.selectedTextBox.CurTextPos = LUI.selectedTextBox.Text:len() end
  end
end

function LUI.textInput(Text)
  if LUI.selectedTextBox ~= nil then
    LUI.selectedTextBox.Text = LUI.selectedTextBox.Text:sub(1,LUI.selectedTextBox.CurTextPos)..Text..LUI.selectedTextBox.Text:sub(LUI.selectedTextBox.CurTextPos+1)
    LUI.selectedTextBox.CurTextPos = LUI.selectedTextBox.CurTextPos +1
  end
end

return LUI
