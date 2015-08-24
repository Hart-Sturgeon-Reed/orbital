window.gameLoop = (time) ->
  game.tick(time)
  
  for sun in game.suns
    sun.self.update()
  
  for particle in game.particles
    particle.update()
    
  for cell in game.cells
    cell.self.update()
    
  ring.update() for ring in game.rings
  
window.game =
  is:
    paused: false
    saving: false
  shot:
    target: null
    ang: null
    force: null
  time: null
  turn: 'purple'
  firstShot: false
  elapsedTime: 6500
  turnTime: 6600
  setShots: []
  soma: []
  cells: []
  suns: []
  particles: []
  rings: []
  
  tick: (newTime) ->
    @elapsedTime += newTime - @time
    unless @elapsedTime < @turnTime
      if @firstShot
        stage.audio.active.fadeTo 0, 500
        stage.audio.passive.fadeTo 80, 500
      #game.is.paused = true 
      @turn = if @turn == 'orange' then 'purple' else 'orange'
      @graphics.drawVectors()
      @graphics.show()
      interactive.applyTo game.cells
    else
      @graphics.hide()
      interactive.applyTo null
    @time = newTime
    
  startMusic: ->
    @firstShot = true
    stage.audio.title.stop()
    stage.audio.passive.loop().play().setVolume(0)
    stage.audio.active.loop().play().setVolume(80)
  
window.startGame = (cen) ->
  console.log 'building game objects'
  game.graphics = new Graphics()
  game.col = Collisions
  #setup game objects
  rad = getRadialSym
  #for cen in rad(3, {x: cen.x + 180, y: cen.y}, {x: cen.x , y: cen.y}, Math.PI/2)
#for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y})
#  pos =
#    x: worldWidth / 3
#    y: worldHeight / 2 
#  orange = new Core({
#    tex: stage.tex.bubble 
#    pos: pos
#    tint: colors.orange
#    team: 'orange'
#  })
##for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y}, Math.PI/3)
#  pos =
#    x: worldWidth * 2 / 3
#    y: worldHeight / 2
#  purple = new Core({
#    tex: stage.tex.bubble 
#    pos: pos
#    tint: colors.purple
#    team: 'purple'
#  })
#  
#  sunCount = if dev == 'mobile' then 3 else 5
#  sun = new Sun({
#    pos: 
#      x: worldWidth/2
#      y: worldHeight/2
#    attractor: true
#  })
#  sun.sprite.scale.x += 0.3
#  sun.sprite.scale.y += 0.3
#    
#  for pos in rad(6, {x: cen.x, y: worldHeight * 0.9}, {x: cen.x, y: cen.y}, Math.PI/3)
#    sun = new Sun({
#      pos: pos
#      tint: colors.ltOrange
#    })
# 
  buildMandalas()
  
  collidable = game.soma.concat bounds.body
  orbitalGrav.applyTo game.cells
  impulse.applyTo collidable
  
  game.time = Date.now()
  stage.audio.title.loop().play()
  Physics.util.ticker.start()