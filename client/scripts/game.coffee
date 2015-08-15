window.gameLoop = (time) ->
  game.tick(time)
  
  for sun in game.suns
    sun.self.update()
  
  for particle in game.particles
    particle.update()
    
  for cell in game.cells
    cell.self.update()
  
window.game =
  is:
    paused: false
  shot:
    target: null
    ang: null
    force: null
  time: null
  turn: 'purple'
  firstShot: false
  elapsedTime: 4500
  turnTime: 4600
  setShots: []
  cells: []
  suns: []
  particles: []
  
  tick: (newTime) ->
    @elapsedTime += newTime - @time
    unless @elapsedTime < @turnTime
      if @firstShot
        stage.audio.active.fadeTo 0, 500
        stage.audio.passive.fadeTo 80, 500
      game.is.paused = true 
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
  for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y})
    sphere = new Cell({
      tex: stage.tex.bubble 
      pos: pos
      tint: colors.orange
      team: 'orange'
    })
  for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y}, Math.PI/3)
    sphere = new Cell({
      tex: stage.tex.bubble 
      pos: pos
      tint: colors.purple
      team: 'purple'
    })
  
  sunCount = if dev == 'mobile' then 3 else 5
  for sun in [1..sunCount]
    sun = new Sun({
      pos: 
        x: rnd {
          min: stageWidth * 0.1
          max: stageWidth* 0.9
        }
        y: rnd {
          min: stageHeight * 0.1
          max: stageHeight* 0.9
        }
    })
      
  collidable = game.cells.concat bounds.body
  orbitalGrav.applyTo game.cells
  impulse.applyTo collidable
  
  game.time = Date.now()
  stage.audio.title.loop().play()
  Physics.util.ticker.start()