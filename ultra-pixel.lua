--ultra pixel v0.8
--by @linoblondelle

function _init()
    t = 0
    score = 0
    hscore = 0
    debug = true
    shake = false
    tshake = 0
    start_moving = false
    --object-- 
    player = {}
    enemy = {}
    particles = {}
    ----------
    _update60 = menu_update
    _draw = menu_draw
   end
   
   function draw_stat()
    if (debug==true) then
    print(stat(0),1,1,0)
    print(stat(1),1,8,0) end
   end
   -------------------
   --choose function--
   function choose(a)
    i = a[flr(rnd(#a)+1)]
    return i
   end
   -------------------
   
   --screen shake--
   function screen_shake() 
    if (shake == true) then
     tshake += 1
     if (tshake>10) tshake = 0 shake = false 
     camera(rnd(10)-5,rnd(10)-5)
    else 
     camera(0,0)
    end
   end
   ----------------
   
   --------------
   --bug effect--
   function bug_effect(size)
     for i=0,size do
     local px = rnd(128)
     local py = rnd(128)
     line(px-rnd(5),py,px+rnd(5),py,pget(px,py))
    end
   end
   
   ---------------------------------
   --function to change enemy size--
   function change_enemy_size()
    for en in all(enemy) do
     en.size = choose({2,3,4,5,6})
     shake = true
     sfx(2)
     if (en.dx>0)and(en.dx<4)then
      en.dx += 0.1 end
     if (en.dx<0)and(en.dx>-4)then
      en.dx -= 0.1 end
    make_particles("empty",p.x,p.y,0,0,15,12,20+rnd(10))
    end
   end
   
   -------------------------
   --draw the with outline--
   function text_outline(text,x,y,col1,col2)
    print(text,x+1,y,col2)
    print(text,x-1,y,col2)
    print(text,x,y+1,col2)
    print(text,x,y-1,col2)
    print(text,x,y,col1)
   end
   
   -------------------------
   -- function game start --
   function game_start()
   --pal(12,choose({1,2,3,4,5,6,8,9,10,11,12,13,14,15}),1)
    make_player()
     for i=0,128,16 do
      local nx = rnd(128)
      local ny = i
      if (ny>12) and
         (ny<116) then
       make_enemy(nx,ny,choose({2,3,4,5,6}))
      end
    end 
    goto_game()
   end
   
   
   ---------------------
   --function game end--
   function game_end()
   
    
    for en in all(enemy) do
      del(enemy,en) 
    end
    for part in all(particles) do
      del(particles,part) 
    end
    del(player,p)
    start_moving = false
    sfx(1)
    goto_over()
   end
   --------------------
   
   -----------------
   --object player--
   function make_player()
    p = {}
    p.x = 64
    p.y = 124
    p.speed = 1.3
    p.dx = 1
    p.dy = -p.speed
    p.size = 3
    add(player,p)
   end
   ----------------
   
   ----------------
   --object enemy--
   function make_enemy(x,y,size)
    en = {}
    en.x = x
    en.y = y
    en.size = size
    en.mode = 1
    if (en.mode==1) en.dx = choose({-1,1})
    add(enemy,en)
   end
   ---------------
   
   --------------------
   --object particles--
   function make_particles(mode,x,y,dx,dy,size,col,tend)
    part = {}
    part.x = x
    part.y = y
    part.dx = dx
    part.dy = dy
    part.size = size
    part.col = col
    part.t = 0
    part.tend = tend 
    part.mode = mode
    add(particles,part)
   end
   
   --------------------
   -- draw the enemy --
   function draw_enemy()
    for en in all(enemy) do
     rectfill(en.x-en.size+1,en.y-en.size+1
             ,en.x+en.size+1,en.y+en.size+1,0)
     rectfill(en.x-en.size,en.y-en.size
             ,en.x+en.size,en.y+en.size,12)
     if (en.mode==1) then
      en.x += en.dx
      if (en.x>128) en.dx = -1 
      if (en.x<0) en.dx = 1
     end
     
     for p in all(player) do
     
      if p.x<en.x+en.size and
         p.y<en.y+en.size and
         p.x>en.x-en.size and
         p.y>en.y-en.size then
         game_end() 
      end
     end
    end 
   end
   
   ----------------------------
   -- funciton update player --
   function update_player() 
    for p in all(player) do
      --increase the x and y
      p.x += p.dx
      p.y += p.dy
      --when the player is on the top
      if (p.y<0) then
      change_enemy_size()
      p.dy = p.speed score += 1 end
      --when the player is on the down
      if (p.y>128) then 
      change_enemy_size()
      p.dy = -p.speed score += 1 end
      --toggle left and right
      if (btnp(4)) then 
       if (p.dx==1) then
        p.dx = -1 sfx(0) else 
        p.dx = 1 sfx(0) end
      end
      -- del player if tuch left of right wall
      if (p.x>128) or (p.x<0) then
       game_end()
      end
    end
   end
   
   
   ---------------------
   -- draw the player --
   function draw_player()
    for d in all(player) do
    pset(p.x+1,p.y+1,0)
    pset(p.x,p.y,12) end
   end
   
   -----------------------
   -- draw the particles --
   function draw_particles()
    for part in all(particles) do
      part.t += 1
      part.size -= 1
     if (part.t>part.tend) del(particles,part)
      part.x += part.dx
      part.y += part.dy
      if (part.mode=="fill") then
      circfill(part.x,part.y,part.size,part.col)end
      if (part.mode=="empty") then
      circ(part.x,part.y,part.size,part.col)end  
    end
   end
   
   
   
   function goto_game()
    _update60 = game_update
    _draw = game_draw 
   end
   
   function goto_menu()
    _update60 = menu_update
    _draw = menu_draw
   end
   
   function goto_over()
    _update60 = over_update
    _draw = over_draw
   end
   ---------
   
   
   function menu_update()
    if (btnp(4)) then
     game_start()
    end
   
   end
   
   function game_update()
    screen_shake()
    if (btnp(4) and start_moving==false) then 
    start_moving = true end
    if (start_moving==true) update_player()
   end
   
   function over_update()
     if (btnp(4)) then
      --update hscore
    if (score>hscore) then
    hscore = score end
    score = 0
    goto_menu() end
   end
   
   
   function menu_draw()
    cls(7)
    t += 0.001
   
    
    local v = sin(t)*50
    spr(5,24,46,10,4)
    
    for i=0,128,16 do
     rectfill(i,128,i+16,128-sin((i-v)/15)*36,12)
     rectfill(i,0,i+16,sin((i-v)/15)*40,12)
    end
    
    text_outline("best : "..hscore,35,91,7,0)
    local text = "press c to play"
    text_outline(text,64-(#text*3)/2-6,82,7,0)
    text_outline("@linoblondelle",2,121,7,0)
    text_outline("v0.8",111,121,7,0)
    --draw_stat()
    
    bug_effect(100)
    
   end
   
   function game_draw()
    cls(7)
    
    for i=0,128,16 do
     rectfill(0,i,rnd(5),i+16,12)
     rectfill(128,i,128-rnd(5),i+16,12)
    end
    
    draw_player()
    draw_particles()
    draw_enemy()
    text_outline(score,8,4,7,0)
    --draw_stat()
    
    if (start_moving==false) then
     local text = "press c to start"
     text_outline(text,64-(#text*2)+sin(time())*3,114,7,0)
    end
    
    bug_effect(100)
   end
   
   function over_draw()
    cls(7)
    local text = "game over"
    text_outline("game over",64-(#text*3)/2-3,64,12,0)
    if (score<hscore) then
    text_outline("score : "..score,47,72,7,0)
    else 
    text_outline("new high score : "..score,47,72,7,0)
    end
    bug_effect(300)
   end