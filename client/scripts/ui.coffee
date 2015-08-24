root = exports ? this

Graphics = ->
  canvas: new PIXI.Graphics()
  overlay: new PIXI.Graphics()
  show: -> 
    stage.ui.addChild @canvas
    stage.marker.sprite.tint = colors.white #colors[game.turn]
    stage.marker.sprite.visible = true
  hide: -> 
    stage.ui.removeChild @canvas
    stage.marker.sprite.visible = false
  
  drawVectors: ->
    @clear()
    @canvas.lineStyle 2, colors.white, 0.1
    for cell in game.cells
      traj = cell.state.pos.clone().vadd(cell.state.vel.clone().mult(160))
      @drawLine cell.state.pos, traj
      
  drawHelper: (pos, traj, valid) ->
    color = if valid then colors.orange else colors.red
    @canvas.lineStyle 2, color, 0.4
    @drawLine pos, traj

  drawLine: (start, end) ->
    @canvas.moveTo start.x, start.y
    @canvas.lineTo end.x, end.y
    
  clear: -> 
    @canvas.clear()

root.Graphics = Graphics unless root.Graphics?