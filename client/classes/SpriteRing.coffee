root = exports ? this

root.SpriteRing = (@opt = {}) ->
  defaults =
    sym: 3
    offset: 10
    origin:
      x: 0, y: 0
    rot: 0
    scale:
      x: 1, y: 1
    alpha: 1.0
    tex: stage.tex.bubble
    sprite: null
    blendMode: PIXI.BLEND_MODES.SCREEN
    tint: colors.white
  @opt[prop] ?= val for prop, val of defaults
  @anim = null
  
  @sprite = new PIXI.Container()
  @children = []
    
  @getPos = ->
    return getRadialSym(@opt.sym, {x: @opt.origin.x, y: @opt.origin.y - @opt.offset}, @opt.origin, @opt.rot)
    
  @animate = (anim = {}) ->
    def =
      rot: 1.0
      off: 1.0
      spd: 1.0
      rev: false
    anim[prop] ?= val for prop, val of def
    @anim = anim
    @anim.totalOffset = @opt.offset
    @anim.baseAlpha = @opt.alpha
    @anim.count = 0
    game.rings.push this
    
  @update = ->
    return unless @anim
    switch @anim.rev
      when false
        c = @anim.count += 0.01 * @anim.spd
      when true
        c = @anim.count -= 0.01 * @anim.spd
    @opt.rot = c * @anim.rot
    @opt.offset = @anim.totalOffset + (Math.cos(c) * @anim.off * @anim.totalOffset)
    
    for pos, i in @getPos()
      @children[i].sprite.position = pos
      
  @init = ->
    for pos in @getPos()
      @opt.pos = pos
      particle = new Particle(@opt)
      @sprite.addChild particle.sprite
      @children.push particle

  @init()
    
  return this