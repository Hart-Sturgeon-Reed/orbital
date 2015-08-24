root = exports ? this

class Core
  constructor: (@opt) ->
    size = if dev == 'mobile' then worldWidth / 36 else worldWidth * 0.018
    options =
        mass: 6.2
        type: 'circle'
        sprite: stage.tex.bubble
        radius: size
        hitBox: {radius: 1}
        angle: 0
        friction: 0.1
        restitution: 0.999
        pos: @opt.pos
        label: 'core',
        alpha: 0.92
        blendMode: PIXI.BLEND_MODES.SCREEN
        
    options[prop] = val for prop, val of @opt
        
    Ent.call(this, options)
    
    @body.self = this
    @body.nextShot = null
    @team = @opt.team
    #@body.follow = player
    #@body.parallax = 1
    
    @charges = []
    @halo = []
    @maxEnergy = 100
    @shotForce = 0.0001
    @energy = @maxEnergy / 2 #rnd(@maxEnergy)
    @scale = 1
    @maxScale = 2
    
    for pos in getRadialSym(3, {x: 0, y: 180}, {x: 0, y: 0})
      ring = new Particle({
        pos: pos
        alpha: 0.94
        tex: stage.tex.bubble
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: @opt.tint
        scale:
          x: 0.6
          y: 0.6
      })
      @sprite.addChild ring.sprite
      @halo.push ring
      ring.sprite.addChild new SpriteRing({
        sym: 7
        offset: 60
        alpha: 0.45
      }).sprite
    
    for pos in getRadialSym(10, {x: 60, y: 0}, {x: 0, y: 0})
      charge = new Particle({
        pos: pos
        tint: colors.ltOrange
        scale:
          x: 0.4
          y: 0.4
      })
      @sprite.addChild charge.sprite
      @charges.push charge
      
    @highlight = ->
      @sprite.alpha = 1
      
    @unhighlight = ->
      @sprite.alpha = options.alpha
    
    @updateEnergy = (cost) ->
      ratio = @energy/@maxEnergy
      numCharges = @charges.length
      for charge, index in @charges
        chargeRatio = (index + 1) / numCharges
        if ratio >= chargeRatio
          if cost?
            shotRatio = (@energy - cost) / @maxEnergy
            unless shotRatio >= chargeRatio
              charge.sprite.tint = colors.red
              charge.sprite.alpha = 0.6
              continue
          charge.sprite.tint = colors.ltOrange
          charge.sprite.alpha = 1.0
        else 
          charge.sprite.tint = colors.white
          charge.sprite.alpha = 0.3
          
    @useEnergy = (amt, massToo = false) ->
      prevEnergy = @energy
      newAmt = @energy - amt
      @energy = if newAmt < 0 then 0 else newAmt
      @updateEnergy()
      
      return unless massToo
      
      change = prevEnergy - @energy
      
      @scale -= (0.4 * (change / @maxEnergy))
      @setScale @scale
      @setMass options.mass * @scale
      
    @hit = (amt) ->
      @scale -= 0.06 * amt
      if @scale < 0.15
        @destroy()
      @scale = if @scale < 0.1 then 0.1 else @scale
      @setScale @scale
      @setMass options.mass * @scale
      
    @destroy = ->
      console.log 'destroyed'
      game.cells.splice game.cells.indexOf(@body), 1
      stage.ents.removeChild @sprite
      world.remove @body
      
      stage.audio.destroy.setTime(0).play()
      
    @addEnergy = (amt, massToo = false) ->
      prevEnergy = @energy
      newAmt = @energy + amt
      @energy = if newAmt > @maxEnergy then @maxEnergy else newAmt
      @updateEnergy()
      
      return #unless massToo
      
      change = @energy - prevEnergy
      
      @scale += (0.4 * (change / @maxEnergy))
      @scale = if @scale > @maxScale then @maxScale else @scale
      @setScale @scale
      @setMass options.mass * @scale
      
    @executeShot = ->
      @useEnergy @body.nextShot.cost
      
      @body.applyForce @body.nextShot.mult(@shotForce * (@body.mass * 0.9))
      @body.nextShot = null
      if game.firstShot
        stage.audio.active.fadeTo 80, 200
        stage.audio.passive.fadeTo 0, 200
      else game.startMusic()
      
      stage.audio.launch.setTime(0).play()
      
    @update = ->
      @body.state.vel.mult(0.9988)
      @body.state.angular.vel *= 0.99
    
    world.add @body
    stage.ents.addChild @sprite
    @updateEnergy()
    game.cells.push @body
    
root.Core = Core