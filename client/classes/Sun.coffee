root = exports ? this

class Sun
  constructor: (@opt) ->
    size = if dev == 'mobile' then worldWidth * 0.05 else worldWidth * 0.04
    range = if dev == 'mobile' then size * 6.5 else worldWidth * 0.3
    options =
        mass: 7
        type: 'circle'
        sprite: stage.tex.wisp
        radius: size
        hitBox: {radius: 0.5}
        angle: 0
        friction: 0.1
        restitution: 0.14
        pos: @opt.pos
        label: 'sun',
        alpha: 0.89
        tint: colors.white
        treatment: 'static'
        blendMode: PIXI.BLEND_MODES.SCREEN
        range: range
        attractor: false
        
    @opt[prop] ?= val for prop, val of options
        
    Ent.call(this, options)
    
    @body.self = this
    #@body.follow = player
    #@body.parallax = 1
    
    @update = ->
      for cell in game.cells
        dist = cell.state.pos.clone().vsub(@body.state.pos).norm()
        if dist < options.range and rnd() > 0.7 + (0.3 * (dist/options.range))
          size = if dev == 'mobile' then rnd {min: 0.2, max: 1.48} else rnd {min: 0.47, max: 1.68}
          pellet = new Particle({
            position: @body.state.pos.clone()
            tint: colors.ltOrange
            tex: stage.tex.wisp
            scale: {x: size, y: size}
            blendMode: PIXI.BLEND_MODES.SCREEN
            alpha: 0.12
            speed: 6.2
            lifetime: worldWidth * 0.6
            vel:
              x: rnd {eql: 18}
              y: rnd {eql: 18}
            mode: 'follow'
            target: cell
            energy: 0.1
          })
          stage.flares.addChild pellet.sprite
          game.particles.push pellet
          
          size = if dev == 'mobile' then rnd {min: 0.17, max: 0.28} else rnd {min: 0.47, max: 0.52}
          pellet = new Particle({
            position: @body.state.pos.clone()
            tint: colors.purple #cell.self.sprite.tint
            tex: stage.tex.wisp
            scale: {x: size, y: size}
            blendMode: PIXI.BLEND_MODES.SCREEN
            alpha: 0.44
            speed: 3.0
            lifetime: worldWidth * 0.4
            vel:
              x: rnd {eql: 1}
              y: rnd {eql: 1}
            mode: 'follow'
            target: cell
            energy: 0.3
          })
          stage.flares.addChild pellet.sprite
          game.particles.push pellet
    
    unless @opt.attractor is false
      @attractor = Physics.behavior('attractor', {
        order: 2
        strength: 0.6
        pos: @opt.pos
        max: worldWidth * 0.6
        min: worldWidth * 0.06
      }) 

      world.add @attractor
    
    @rings = []
    
    for pos in getRadialSym(6, {x: 40, y: 0}, {x: 0, y: 0}, rnd Math.PI)
      ring = new Particle({
        pos: pos
        alpha: 0.4
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: @opt.tint
        scale:
          x: 0.6
          y: 0.6
      })
      @sprite.addChild ring.sprite
      @rings.push ring
    for pos in getRadialSym(7, {x: 40, y: 0}, {x: 0, y: 0})
      ring = new Particle({
        pos: pos
        alpha: 0.2
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: @opt.tint
        tex: stage.tex.bubble
        scale:
          x: 0.7
          y: 0.7
      })
      @sprite.addChild ring.sprite
      @rings.push ring


    world.add @body
    stage.suns.addChild @sprite
    game.suns.push @body
    
root.Sun = Sun