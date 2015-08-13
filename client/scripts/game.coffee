window.gameLoop = (time) ->
  game.tick(time)
  
  for sun in game.suns
    sun.self.update()
  
  for particle in game.particles
    particle.update()
  
window.game =
  is:
    paused: false
  shot:
    target: null
    ang: null
    force: null
  time: null
  elapsedTime: 3500
  turnTime: 3600
  setShots: []
  cells: []
  suns: []
  particles: []
  
  tick: (newTime) ->
    @elapsedTime += newTime - @time
    unless @elapsedTime < @turnTime
      game.is.paused = true 
      @graphics.drawVectors()
      @graphics.show()
      interactive.applyTo game.cells
    else
      @graphics.hide()
      interactive.applyTo null
    @time = newTime
  
window.startGame = (cen) ->
  console.log 'building game objects'
  game.graphics = new Graphics()
  #setup game objects
  rad = getRadialSym
  #for cen in rad(3, {x: cen.x + 180, y: cen.y}, {x: cen.x , y: cen.y}, Math.PI/2)
  for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y})
    sphere = new Cell({
      tex: stage.tex.bubble 
      pos: pos
      tint: colors.orange
    })
  for pos in rad(3, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y}, Math.PI/3)
    sphere = new Cell({
      tex: stage.tex.bubble 
      pos: pos
      tint: colors.purple
    })
      
  for sun in [1..3]
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
      
  collidable = game.cells.concat game.suns, bounds.body
  impulse.applyTo collidable
  
  game.time = Date.now()
  Physics.util.ticker.start()