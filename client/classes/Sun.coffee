root = exports ? this

class Sun
  constructor: (@opt) ->
    size = if dev == 'mobile' then worldWidth * 0.05 else worldWidth * 0.03
    absorption = if dev == 'mobile' then size * 6.5 else worldWidth * 0.2
    options =
        mass: 18
        type: 'circle'
        sprite: stage.tex.wisp
        radius: size
        hitBox: {radius: 0.5}
        angle: 0
        friction: 0.1
        restitution: 0.24
        pos: @opt.pos
        label: 'cell',
        alpha: 0.89
        tint: colors.white
        treatment: 'static'
        blendMode: PIXI.BLEND_MODES.SCREEN
        range: absorption
        
    Ent.call(this, options)
    
    @body.self = this
    #@body.follow = player
    #@body.parallax = 1
    
    @update = ->
      for cell in game.cells
        dist = cell.state.pos.clone().vsub(@body.state.pos).norm()
        if dist < options.range and rnd() > 0.7 + (0.3 * (dist/options.range))
          size = if dev == 'mobile' then rnd {min: 0.17, max: 0.38} else rnd {min: 0.47, max: 0.68}
          pellet = new Particle({
            position: @body.state.pos.clone()
            tint: colors.ltOrange
            tex: stage.tex.wisp
            scale: {x: size, y: size}
            blendMode: PIXI.BLEND_MODES.SCREEN
            alpha: 0.3
            speed: 0.9
            lifetime: 800
            vel:
              x: rnd {eql: 1}
              y: rnd {eql: 1}
            mode: 'follow'
            target: cell
            energy: 0.3
          })
          stage.ents.addChild pellet.sprite
          game.particles.push pellet
    
    @attractor = Physics.behavior('attractor', {
      order: 1
      strength: 0.003
      pos: @opt.pos
      max: worldWidth * 0.3
      min: 80
	})
    
    world.add @attractor
    
    @rings = []
    
    for pos in getRadialSym(6, {x: 40, y: 0}, {x: 0, y: 0}, rnd Math.PI)
      ring = new Particle({
        pos: pos
        alpha: 0.4
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: colors.ltOrange
        scale:
          x: 0.6
          y: 0.6
      })
      @sprite.addChild ring.sprite
      @rings.push ring
    for pos in getRadialSym(7, {x: 40, y: 0}, {x: 0, y: 0})
      ring = new Particle({
        pos: pos
        alpha: 0.19
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: colors.ltOrange
        tex: stage.tex.bubble
        scale:
          x: 0.7
          y: 0.7
      })
      @sprite.addChild ring.sprite
      @rings.push ring


    world.add @body
    stage.ents.addChild @sprite
    game.suns.push @body
    
root.Sun = Sun