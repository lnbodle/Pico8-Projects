--bonzai by @linoblondelle
--v1.0

poke(0x5f2d, 1)
mouse={x=stat(32),y=stat(33),b=stat(34)}

function _init()
 rooms[room_index].init()
end

function _update()
 --set the variables
 mouse={x=stat(32),y=stat(33),b=stat(34)}
 --update the rooms 
 rooms[room_index].update()
 --update the objects
 for i,o in pairs(objects) do
  if (o.init==true) o.id.init(o) o.init=false
  o.id.update(o)
 end
end

function _draw()
 --update the rooms
 rooms[room_index].draw()
 --update objects
 for i,o in pairs(objects) do
  o.id.draw(o)
 end
 --draw some debug things
 --print(count_object(part),1,16)
 --print(flr(stat(1)*100).." / 100%",1,1)
 --print(stat(7).." / fps",1,8)
end
-->8
--where you add function 
function print_outline(t,x,y,c1,c2)
 print(t,x+1,y,c2)
 print(t,x-1,y,c2)
 print(t,x,y+1,c2)
 print(t,x,y-1,c2)
 print(t,x,y,c1)
end 

function direction(x1,y1,x2,y2) 
 return atan2(x2-x1,y2-y1)-0.25
end

function distance(x1,y1,x2,y2)
 return sqrt((x2-x1)^2+(y2-y1)^2)
end

function count_object(n) 
 local c = 0
 for o in all(objects) do
  if (o.id == n) c += 1
 end
 return c
end

function remap(s,a1,a2,b1,b2) 
 return b1+(s-a1)*(b2-b1)/(a2-a1)
end

function lerp(a,b,f)
  return a + f * (b - a)
end

function linecircle(x1,y1,x2,y2,cx,cy,r) 
  local inside1 = pointcircle(x1,y1, cx,cy,r)
  local inside2 = pointcircle(x2,y2, cx,cy,r)
  if (inside1 or inside2) return true
  local distx = x1 - x2;
  local disty = y1 - y2;
  local len = sqrt( (distx*distx) + (disty*disty) )
  local dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / len^2
  local closestx = x1 + (dot * (x2-x1))
  local closesty = y1 + (dot * (y2-y1))
  local onsegment = linepoint(x1,y1,x2,y2, closestx,closesty)
  if (not onsegment) return false
  distx = closestx - cx
  disty = closesty - cy
  local distance = sqrt( (distx*distx) + (disty*disty) )
  if (distance <= r) then
    return true
  end
  return false
end

function pointcircle(px,py,cx,cy,r) 
  local distx = px - cx
  local disty = py - cy
  local distance = sqrt( (distx*distx) + (disty*disty) )
 if (distance <= r) then
    return true
 end
  return false
end

function linepoint(x1,y1,x2,y2,px,py) 
  local d1 = distance(px,py, x1,y1)
  local d2 = distance(px,py, x2,y2)
  local linelen = distance(x1,y1, x2,y2)
  local buffer = 0.1  
  if (d1+d2 >= linelen-buffer and d1+d2 <= linelen+buffer) then
    return true
  end
  return false
end

function fill_tri(x1,y1,x2,y2,x3,y3,c)
    if y1>y2 then y1,y2=y2,y1 x1,x2=x2,x1 end
    if y2>y3 then y2,y3=y3,y2 x2,x3=x3,x2 end
    if y1>y2 then y1,y2=y2,y1 x1,x2=x2,x1 end
    if y2>y3 then y2,y3=y3,y2 x2,x3=x3,x2 end


    if y1==y2 and y2==y3 then line(x2,y2,x3,y3,c or 8) return end

    if y1==y2 then
        fill_top_tri(x1,y1,x2,y2,x3,y3,c)
    elseif y2==y3 then
        fill_bottom_tri(x1,y1,x2,y2,x3,y3,c)
    else
        local x4,y4=x1+((y2-y1)/(y3-y1))*(x3-x1),y2
        line(x2,y2,x4,y4,c or 8)
        fill_bottom_tri(x1,y1,x2,y2,x4,y4,c)
        fill_top_tri(x2,y2,x4,y4,x3,y3,c)
    end   
end

function fill_bottom_tri(x1,y1,x2,y2,x3,y3,c,p)
    local inv1=(x2-x1)/(y2-y1)
    local inv2=(x3-x1)/(y3-y1)
    local cx1=x1
    local cx2=x1
   
    for i=y1,y2 do
     line(cx1,i,cx2,i,c or 8)
        cx1+=inv1
        cx2+=inv2
    end
end

function fill_top_tri(x1,y1,x2,y2,x3,y3,c,p)
    local inv1=(x3-x1)/(y3-y1)
    local inv2=(x3-x2)/(y3-y2)
    local cx1=x3
    local cx2=x3
   
    for i=y3,y1,-1 do
        line(cx1,i,cx2,i,c or 8)
        cx1-=inv1
        cx2-=inv2
    end
end

function line_width(x1,y1,x2,y2,w,c1,c2)  
 local d = direction(x1,y1,x2,y2)
 local nw = w/2
 local nsin = sin(d-0.25)
 local ncos = cos(d-0.25)
 local psin = sin(d+0.25)
 local pcos = cos(d+0.25)
 local tx1,ty1 = x1+psin*nw,y1-pcos*nw
 local tx2,ty2 = x1+nsin*nw,y1-ncos*nw
 local ux1,uy1 = x2+psin*nw,y2-pcos*nw
 local ux2,uy2 = x2+nsin*nw,y2-ncos*nw
 local ux3,uy3 = tx1,ty1
 local tx3,ty3 = ux2,uy2

 fill_tri(tx1,ty1,tx2,ty2,tx3,ty3,c1)
 fill_tri(ux1,uy1,ux2,uy2,ux3,uy3,c2)
end







-->8
--where you draw the game
room_index = 1

rooms = {
 {
  init = function()
  add_object(tree,64,100)
  end
  ,
  update = function()
  if (mouse.b==1) add_object(mouse_effect,mouse.x,mouse.y)
  end
  ,
  draw = function()
   cls(1)
   circfill(64,96,16,9)
   rectfill(0,96,127,127,13)
   spr(1,mouse.x-3,mouse.y-3)
  end
 }
}
-->8
--where you create object
objects = {}

function add_object(id,x,y)
 local o = {}
 o.x = x
 o.y = y
 o.id = id
 o.init = true
 add(objects,o)
 return o
end

--add object here--
empty = {
 init = function(o)
 end
 ,
 update = function(o)
 end
 ,
 draw = function(o)
 end
}

mouse_effect = {
 init = function(o)
  o.t = 3
 end
 ,
 update = function(o)
  o.t -= 0.2
  if (o.t<0) del(objects,o)
 end
 ,
 draw = function(o)
  circfill(o.x,o.y,o.t,7)
 end
}

part = {
 init = function(o)
  o.dx = 2
  o.dy = -3
  o.g = 0.5
 end
 ,
 update = function(o)
  o.x1 += o.dx
  o.y1 += o.dy
  o.x2 += o.dx
  o.y2 += o.dy
  o.dy += o.g
  if (min(o.y1,o.y2)>128) del(objects,o)
 end
 ,
 draw = function(o)
  line_width(o.x1,o.y1,o.x2,o.y2,o.thickness,4,1)
 end
}

tree = {

 init = function(o)
  --here i create independant 
  --object called branchs
  o.branches = {}
  
  o.add_branch = function(x,y,size_max,a)
  local b = {}
   b.x1 = x
   b.y1 = y
   b.x2 = x
   b.y2 = y
   b.size = 0
   b.size_max = size_max
   b.angle = a
   b.start = true
   b.get = {}
   b.geted = nil
   b.id = b
   b.thickness = 0
   add(o.branches,b)
   return b
  end
  
  o.del_branch = function(d) 
   for u=1,#d.get do
     if d.get!={} then
      o.del_branch(d.get[u])
     end
   end
   local n = add_object(part,0,0)
   n.x1 = d.x1
   n.y1 = d.y1
   n.x2 = d.x2
   n.y2 = d.y2
   n.thickness = d.thickness
   del(o.branches,d)
  end
  
  o.remove_branch_from_list = function(d)
   if (d.geted != nil) then
    local check = d.geted.get 
    for u=1,#check do
     if check[u]==d.id then
      del(check,d.id)
     end
    end
   end
  end

  o.branch_max = 30
  o.angle = 0
  local new = o.add_branch(o.x,o.y,10,-0.1)
  local new = o.add_branch(o.x,o.y,10,0.1)
 end
 ,
update = function(o)
  
 if (#o.branches==0) then
  local new = o.add_branch(o.x,o.y,10,-0.1)
  local new = o.add_branch(o.x,o.y,10,0.1)
 end
   
 for i,b in pairs(o.branches) do
   
  --check if number of branch don't go upper max size
  if (#o.branches<o.branch_max) then
   
   if (b.size<b.size_max) then 
    --lerp the size to his max
    b.size = lerp(b.size,b.size_max+0.1,0.2)
   else
    if (b.start==true) then
     
     --add the main branch 
     local new = o.add_branch(b.x2,b.y2,10+rnd(5),b.angle-0.125+rnd(0.25))
     new.geted = b.id
     add(b.get,new.id)
     
     --add some random branch
     for i=0,flr(rnd(2)) do
      local new = o.add_branch(b.x2,b.y2,2+rnd(10),-0.25+rnd(0.5))
      new.geted = b.id
      add(b.get,new.id)
     end
     b.start=false--end the branch
    end
   end
  end
  
  --if the mouse is pressed
  --check if the is a collsion
  --with line and if destroy it
  if mouse.b==1 then
   if linecircle(b.x1,b.y1,b.x2,b.y2,mouse.x,mouse.y,2) then
    sfx(0)
    o.del_branch(b)
    o.remove_branch_from_list(b)
   end
  end
  
  --set the postion of x2,y2
  --with the angle
  b.x2 = lerp(b.x2,b.x1+sin(b.angle)*b.size,0.2)
  b.y2 = lerp(b.y2,b.y1-cos(b.angle)*b.size,0.2)
  
  --for all branch he get
  --set the position to 
  --his x2,y2
  for u=1,#b.get do
   b.get[u].x1 = b.x2
   b.get[u].y1 = b.y2
  end
  
  --if its the strting branch
  --set postion to player
  if (b.geted==nil) then
   b.x1 = o.x
   b.y1 = o.y
  end
  
  --set the thickness
  b.thickness = remap(i,0,#o.branches,4,1)
 end
 
end
 ,
 draw = function(o)
  --draw the pot
  spr(64,o.x-7,o.y,2,2)
  
  for i,b in pairs(o.branches) do
    --draw branches
    line_width(b.x1,b.y1,b.x2,b.y2,b.thickness,4,1)
    --draw leavs
    if (#b.get == 0) then
     circfill(b.x2,b.y2,4,3)
     circfill(b.x2+2,b.y2,4,11)
    end
   end
  end
}
