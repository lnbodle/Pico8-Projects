--cir-ne by lino blondelle
--music by justin ray
--version 1.0

--choose beetween number
function choose(a)
    i = a[flr(rnd(#a)+1)]
    return i
   end
   --lengthdir_x
   function lengthdir_x(d,l1,l2)
   x = sin(d)*(l1+l2)
   return x
   end
   --lengthdir_y--
   ---------------
   function lengthdir_y(d,l1,l2)
   y = cos(d)*(l1+l2)
   return y
   end
   --print shadow--
   ----------------
   function print_shadow(text,x,y,col,col2)
    print(text,x+1,y+1,col2)
    print(text,x,y,col)
   end
   
   function save_score(score)
     poke(0x5fc0, flr(score/256))
     poke(0x5fc0, score % 256)
   end
   
   function load_score()
     return peek(0x5fc0) + peek(0x5fc1)
   end
   
   --object--
   ----------
   player = {}
   enemies = {}
   particles = {}
   sobj = {}
   
   --variables--
   -------------
   score = 0
   hscore = load_score()
   game_start = false
   pplay = "press c to play"
   col1 = choose({1,2,3,5})
   col2 = choose({8,9,15,12,14})
   player.col = col2
   dist = 64
   t = 0
   alarm = 0
   music(10,100)
   --gane end function--
   ---------------------
   function game_end()
    sfx(1)
    alarm = 0
    score = 0
    col1 = choose({1,2,3,5})
    col2 = choose({8,9,15,12,14})
    for i=1,#enemies  do
     del(enemies,enemies[1])
     game_start = false
     del(player,p)
     del(sobj,s)
     save_score(hscore)
     music(-1,100)
     music(10,100)
    end
   end
   
   --make player--
   ---------------
   function make_player()
    music(0)
    p = {}
    p.col = col2
    p.x = 64
    p.y = 64
    p.x2 = 64
    p.y2 = 64
    p.d = 0.1
    p.mode = 0
    add(player,p)
   end
   
   --make enemie--
   ---------------
   function make_enemie()
    e = {}
    e.mode = flr(rnd(2))
    e.angle = 0.5
    e.x = -5
    e.y = -5
    e.col = col1
    e.speed = choose({-0.007,0.007})
    e.t = 0
    e.cl = 0
    e.size = 0
    add(enemies,e)
   end 
   
   --make particles--
   ------------------
   function make_particles(x,y,col,size)
    part = {}
    part.x = x
    part.y = y
    part.dx = rnd(2)-1
    part.dy = rnd(2)-1
    part.col = col
    part.size = size
    add(particles,part)
   end
   
   --make spawner--
   ----------------
   function make_sobj()
    s = {}
    s.x = -5
    s.y = -5
    s.angle = rnd(100)*0.01
    add(sobj,s)
   end
   
   --draw sobj--
   -------------
   function draw_sobj()
    for s in all(sobj) do
     for p in all (player) do
     circfill(s.x,s.y,2,7)
    -- circfill(s.x,s.y,3,col2)
    if s.angle > 1 then
      s.angle = 0 end
     s.x = 64+lengthdir_x(s.angle,dist,0)
     s.y = 64-lengthdir_y(s.angle,dist,0) 
       --colision with player
     if s.angle > p.d-0.01 and
        s.angle < p.d+0.01 then
       while i<10 do
       make_particles(s.x,s.y,7,2)
       i+=1
       end 
        score += 1
        sfx(2)
       if #sobj < 2 then
         make_sobj()
        end 
       del(sobj,s)
      end
     end
    end
   end
   
   --draw particles--
   ------------------
   function draw_particles()
    for part in all(particles) do
     --draw part
     circfill(part.x,part.y,part.size,part.col)
     --set part
     part.x += part.dx
     part.y += part.dy
     part.size -= 0.2
     if part.size < 0 then
     del(particles,part) end
    end
   end
   
   --draw player--
   ---------------
   function draw_player()
    for p in all(player) do
    line(p.x,p.y,
         p.x2,p.y2,p.col)
    if game_start == true then
     --change mode
    if btnp(4) then
    while i<15 do
       make_particles(p.x,p.y,p.col,2)
       i+=1
      end
     if p.mode == 0 then
     p.mode = 1
     p.col = col1
     sfx(0)
    else
     p.mode = 0 
     p.col = col2
     sfx(0)
    end
   end
    -- test angle
    if p.d > 1 then p.d = 0 end
    if p.d < 0 then p.d = 1 end
    -- change angle
    if btn(0) then p.d += 0.01 end
    if btn(1) then p.d -= 0.01 end
    -- first player position
    p.x = 64+lengthdir_x(p.d,dist,0)
    p.y = 64-lengthdir_y(p.d,dist,0)
    -- scond plaer position
    if p.mode == 0 then
      p.x2 = 64+lengthdir_x(p.d,dist,12)
      p.y2 = 64-lengthdir_y(p.d,dist,12)
    else if p.mode == 1 then
      p.x2 = 64+lengthdir_x(p.d,dist,-12)
      p.y2 = 64-lengthdir_y(p.d,dist,-12)
      end
     end
    end
   end
   
   --draw enemie--
   ---------------
   function draw_enemie()
   for p in all(player) do
    for e in all(enemies) do
    e.t += 1 
    --destroy enemie
    if e.t > 140 then
     while i<5 do
       make_particles(e.x,e.y,e.col,2)
       i+=1
       end
       del(enemies,e)
     end
   -- if e.cl > 2 then e.cl = 0 end
   -- if e.t < 15 then
    -- if e.cl < 2 then
     -- e.cl += 1
      if (e.size<3) then
      e.size += 0.2
      circfill(e.x,e.y,e.size,7)
      else  -- end 
      circfill(e.x,e.y,e.size,e.col)
      end
   -- else
     -- circfill(e.x,e.y,3,e.col)
   
    --check mode
     if e.mode == 1 then
      e.col = col2
      e.x = 64+lengthdir_x(e.angle,dist,7)
      e.y = 64-lengthdir_y(e.angle,dist,7)
     end
     if e.mode == 0 then
      e.col = col1
      e.x = 64+lengthdir_x(e.angle,dist,-7)
      e.y = 64-lengthdir_y(e.angle,dist,-7)
     end
       e.angle += e.speed
     -- test angle
     if e.angle > 1 then e.angle = 0 end
     if e.angle < 0 then e.angle = 1 end
     
     --colision with player
     if e.angle > p.d-0.01 and
        e.angle < p.d+0.01 and
        e.t > 15 and
        e.col == p.col then
        game_start = false
        game_end() end 
      end
     end
    end
   end
   
   
   function _update()
   alarm += 1
    --make enemie
    if game_start == true then
    if alarm > 30 then
      make_enemie()
      alarm = 0
     end
    end
    --set high score
    if score > hscore then
    hscore = score end
    --start game
    if btnp(4)and game_start==false then
     alarm = 0
     make_player()
     make_sobj()
     game_start = true
    end
    --update time
    t += 0.1
    --change global distance
    dist = 32+sin(t/10)*15
   end
   function _draw()
    cls()
    --draw backgroud
    rectfill(0,0,128,128,col1)
    --draw circle
    circfill(64,64,dist,col2)
    --draw score
    if game_start == true then
    print_shadow("score:"..score, 2,2,col2,0) end
    --draw menu
    if game_start == false then
    print_shadow("v1.0",111,121,col2,0)
    
    print_shadow("music by justin ray",
    2,121,col2,0)
    
    print_shadow("code/art by lino blondelle",
    2,114,col2,0)
     
    -- circ(64+sin(t/5)*16,47+sin(t/5)*5,7,7)
     
    -- spr(0,40,44+sin(t/5)*5,6,1)
     for mx=0,48*2 do for my=0,8*2 do
      local p = sget(mx/2,my/2)
      if p!=0 then
      pset(16+mx+1,44+my+sin((mx-t*20)/100)*5+1,0)
      pset(16+mx,44+my+sin((mx-t*20)/100)*5,p) end
     end end 
     
     --print(load_score(),64,64)
     print_shadow("high score:"..hscore,2,2,col2,0) 
      for i=0,#pplay,1 do
       print_shadow(sub(pplay,i,i),
       30+(i*4),
       68+(#pplay/2)+sin(((t*10)+i)/25)*3,7,0) end
    end
    draw_player()
    draw_enemie()
    draw_particles()
    draw_sobj()
   end