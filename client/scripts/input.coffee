window.setupInput = ->
  stage.marker = new Marker()
  stage.ui.addChild stage.marker.sprite

window.input =
  grabStarted: false
  
  keyPressed: (data) ->
    console.log data.which
    switch data.keyCode
      when 82
        console.log 'r'#generate new mandalas
        refreshMandalas()
      when 83 #s
        #set save mode
        console.log 's'
        game.is.saving = true
      when 71
        console.log 'g'
        name = prompt 'Enter the name of the creature you would like to find:'
        if name?
          displayMandala getGenome name
        else
          console.log 'canceled search'
      when 67
        console.log 'c'
      when 77
        console.log 'm'
  
  startGrab: (data) ->
    #attractor.position( data )
    #world.add( attractor )
    world.wakeUpAll()
    
    return unless game.is.paused and data.body.self.sprite.tint == colors.white #colors[game.turn]
    
    @grabStarted = true
    
    data.body.self.highlight()
    
    stage.marker.sprite.tint = colors.white #colors[game.turn]
    stage.marker.sprite.position =
      x: data.x
      y: data.y
    stage.marker.sprite.alpha = 1.0 if dev is 'mobile'
    game.is.paused = true
  
  endGrab: (data) ->
    #world.remove( attractor );
    return unless @grabStarted
    @grabStarted = false
    
    data.body?.self.unhighlight()
    
    stage.marker.sprite.tint = colors.white #colors[game.turn]
    stage.marker.sprite.alpha = 0 if dev is 'mobile'
    
    if data.body.nextShot? and data.body.nextShot.clone().norm() > 10 and data.body.nextShot.valid?
      data.body.self.executeShot()
      
      game.is.paused = false
      game.elapsedTime = 0
      game.time = Date.now()
    
  onMove: (data) ->
    stage.marker.sprite.position =
      x: data.x
      y: data.y
      
    if data.body? and @grabStarted
      data.body.nextShot =
        data.body.state.pos.clone().vsub(Physics.vector data.x, data.y).negate()
        
      cost = data.body.nextShot.clone().norm() / 2.6
      if cost < data.body.self.energy
        stage.marker.sprite.tint = colors.white #colors[game.turn]
        data.body.nextShot.valid = true
        data.body.nextShot.cost = cost
      else 
        stage.marker.sprite.tint = colors.red
        data.body.nextShot.normalize().mult(data.body.self.energy * 3.6)
        cost = data.body.self.energy
        data.body.nextShot.valid = true
        data.body.nextShot.cost = cost
      data.body.self.updateEnergy(cost)
        
      traj = data.body.state.pos.clone().vadd(data.body.nextShot.clone().mult(0.82))
      game.graphics.drawVectors()
      game.graphics.drawHelper data.body.state.pos, traj, data.body.nextShot.valid?
      game.graphics.show()
  
  cancelShot: (data) ->
  
  endTurn: ->
  