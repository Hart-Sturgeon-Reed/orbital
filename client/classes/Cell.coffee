root = exports ? this

class Cell
  constructor: (@opt) ->
    size = if dev == 'mobile' then worldWidth / 36 else worldWidth * 0.016
    options =
        mass: 2.2
        type: 'circle'
        sprite: stage.tex.bubble
        radius: size
        hitBox: {radius: 1}
        angle: 0
        friction: 0.1
        restitution: 0.999
        pos: @opt.pos
        label: 'cell',
        alpha: 0.42
        
    options[prop] = val for prop, val of @opt
        
    Ent.call(this, options)
    
    @body.self = this
    #@body.follow = player
    #@body.parallax = 1
    
    @charges = []
    @halo = []
    @maxEnergy = 100
    @shotForce = 0.0020
    @energy = @maxEnergy / 2 #rnd(@maxEnergy)
    @scale = 1
    
    for pos in getRadialSym(6, {x: 0, y: 180}, {x: 0, y: 0})
      ring = new Particle({
        pos: pos
        alpha: 0.24
        tex: stage.tex.bubble
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: colors.white
        scale:
          x: 1.9
          y: 1.9
      })
      #@sprite.addChild ring.sprite
      #@halo.push ring
    
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
      @sprite.alpha = 0.8
      
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
          
    @useEnergy = (amt) ->
      prevEnergy = @energy
      newAmt = @energy - amt
      @energy = if newAmt < 0 then 0 else newAmt
      @updateEnergy()
      
      change = prevEnergy - @energy
      
      @scale -= (0.4 * (change / @maxEnergy))
      @setScale @scale
      @setMass options.mass * @scale
      
    @addEnergy = (amt) ->
      prevEnergy = @energy
      newAmt = @energy + amt
      @energy = if newAmt > @maxEnergy then @maxEnergy else newAmt
      @updateEnergy()
      
      change = @energy - prevEnergy
      
      @scale += (0.4 * (change / @maxEnergy))
      @setScale @scale
      @setMass options.mass * @scale
      
    @executeShot = ->
      @useEnergy @body.nextShot.cost
      
      @body.applyForce @body.nextShot.mult(@shotForce)
      @body.nextShot = null
    
    world.add @body
    stage.ents.addChild @sprite
    @updateEnergy()
    game.cells.push @body
    
root.Cell = Cell