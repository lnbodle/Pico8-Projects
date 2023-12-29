function _init()
    --nothing here
    score = 0
    best_score = 0
    difficulty = 0
    
    rooms[room_index].init()
   end
   
   function _update60()
    --init and update rooms--
    if (rooms[room_index].start==true) then
       rooms[room_index].init()
       rooms[room_index].start=false
    end
    rooms[room_index].update()
    ----update all objects----
    for o in all(objects) do
        if (o.start==true) then
           o.name.init(o) 
           o.start = false
        end
        o.name.update(o)
    end
    --------------------------
   end
   
   function _draw()
    cls()
    rooms[room_index].draw()
    ----draw all objects----
    for o in all(objects) do
        o.name.draw(o)
    end
    --------------------------
   end
   
   -->8
   ----add object here----
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
   
   puf = {
    init = function(o) 
     o.s = 2+rnd(3)
     o.dx = rnd(2)-1
     o.dy = rnd(2)-1
    end
    ,
    update = function(o)
     o.x += o.dx 
     o.y += o.dy
     o.s -= 0.1
     if (o.s<0) del(objects,o)
    end
    ,
    draw = function(o)
     circfill(o.x,o.y,o.s,7)
    end
   }
   
   fruit = {
    init = function(o) 
     o.img = 17+flr(rnd(3))
     o.dx = 0
     o.dy = -2
     o.life = 10
     o.g = 0.1
     o.box = {x=o.x,y=o.y,width=8,height=8}
    end
    ,
    update = function(o)
     o.box = {x=o.x,y=o.y,width=8,height=8}
     
     o.dy += o.g
     o.x += o.dx
     o.y += o.dy
     
     if (o.y>128) then
     room_goto(3)
     del(objects,o)
     end
     
     if (o.life<0) then
        for i=0,10 do add_object(puf,o.x,o.y) end
        score += 1
        sfx(1)
        del(objects,o)
     end
     
     if (o.x>120) o.dx = -1
     if (o.x<0) o.dx = 1
     
     for n in all(objects) do
      if (n.name == player) then
         if (collision_box(o.box,n.box)) then
          o.life -= 1
          o.dy = -3-difficulty/2
          o.dx = rnd(2)-1
         end
      end
     end
     
    end
    ,
    draw = function(o)
     spr(o.img,o.x,o.y)
    end
   }
   
   cloud = {
    init = function(o) 
    o.t  = 0
    o.tm = 20+rnd(50)
    end
    ,
    update = function(o)
     if (o.t>o.tm) then
        if (count_object(fruit)<=difficulty) then
           add_object(fruit,o.x,o.y)
        end
        o.t = 0
        o.tm = 20+rnd(50)
     else
        o.t += 1
     end
     
     o.x  = 64+sin(time()/5)*32
    end
    ,
    draw = function(o)
    circfill(o.x,o.y,10,7)
    circfill(o.x+10,o.y+5,10,7)
    circfill(o.x-10,o.y+5,10,7)
    spr(5,o.x-8,o.y-6,2,2)
    end
   }
   
   player = {
    init = function(o) 
    o.box = {x=o.x,y=o.y,width=8,height=8}
    end
    ,
    update = function(o)
    o.box = {x=o.x,y=o.y,width=8,height=8}
    
     if (btn(1) and o.x < 120) o.x += 3 
     if (btn(0) and o.x > 0) o.x -= 3 
    end
    ,
    draw = function(o)
    spr(1+(time()*5)%4,o.x,o.y)
    end
   }
   
   -----------------------
   objects = {}
   function add_object(name,x,y)
            local o = {}
            o.name = name
            o.x = x
            o.y = y
            o.start = true
            add(objects,o)
            return o
   end
   -->8
   --create the game--
   -------------------
   room_index = 1
   
   rooms = {
    
    --main menu--
    -------------
    {
    start = true
    ,
    init = function(o) 
     create_cloud()
    end
    ,
    update = function(o)
     if (btnp(2)) room_goto(2)
    end
    ,
    draw = function(o)
     cls(12)
     
     print_out('best : ' ..best_score,1,1,7) 
     
     for i=0,12 do
         print_out("super summer (press ⬆️)",i*100+(time()*5)%100-100,64,7)
     end
     
     draw_cloud()
    end
    }
    
    ,
    --main game--
    -------------
    {
    start=true
    ,
    init = function(o)
    
      t = 0
      score = 0
      player_1 = add_object(player,64,100)
      add_object(cloud,64,32)
    
    end
    ,
    update = function(o)
      
      if (score>best_score) best_score = score
      
      local d = {5,10,20}
      local n = {0,1,2}
      for i=1,#d do
          if (score>=d[i]) difficulty = n[i]
      end
      
    end
    ,
    draw = function(o) 
    
      cls(6)
      map(0,0,0,0,16,16)
      --rectfill(0,120,128,128,0)
      print_out(score,2,120,7)
     
    end
    }
    ,
    --game over--
     {
    start = true
    ,
    init = function(o) 
     objects = {}
     create_cloud()
    end
    ,
    update = function(o)
     if (btnp(2)) room_goto(1)
    end
    ,
    draw = function(o)
     cls(12)
     print_out("score : " ..score,1,1,7)
     
     local d = 54 
     for i=0,12 do
         print_out("game over",i*d+(time()*5)%d-d,64,7)
     end
     
     draw_cloud()
    end
    }
   }
   
   -->8
   --function 
   function collision_box(b1,b2) 
       if (b1.x < b2.x + b2.width and
          b1.x + b1.width > b2.x and
          b1.y < b2.y + b2.height and
          b1.height + b1.y > b2.y) then
          return true 
       end
   end
   
   function count_object(name)
    count = 0
    for o in all(objects) do
     if (o.name==name) count += 1
    end
    return count
   end
   
   function room_goto(num) 
    rooms[num].start = true
    room_index = num
   end
   
   function print_out(text,x,y,c)
    print(text,x+1,y+1,0)
    print(text,x,y,c)
   end
   
   function create_cloud()
    s = {}
    for i=0,10 do
     add(s,10+rnd(20))
    end
   end
   
   function draw_cloud()
     for i=1,#s do
      circfill(i*20-20,128+sin((time()-i)/10)*5,s[i],7)
     end 
   end