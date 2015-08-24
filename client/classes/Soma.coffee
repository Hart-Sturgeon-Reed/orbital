root = exports ? this

class Soma
  constructor: (@opt = {}) ->
    @opt.size ?= if dev == 'mobile' then worldWidth / 36 else worldWidth * 0.01
    
    if @opt.genome?
      @genome = @opt.genome
    else
      @genome = new Genome()
    
    defaults =
        mass: 6.2
        type: 'circle'
        sprite: stage.tex.bubble
        radius: @opt.size
        hitBox: {radius: 6}
        angle: 0
        friction: 0.1
        restitution: 0.699
        pos: {x: rnd(worldWidth), y: rnd(worldHeight)}
        vel:
          x: 0 #rnd {eql: 0.2}
          y: 0 #rnd {eql: 0.2}
        label: 'soma',
        alpha: 0.92
        blendMode: PIXI.BLEND_MODES.SCREEN
        tint: @getColor()
        
    applyDefaults @opt, defaults
        
    Ent.call(this, @opt)
    
    @body.self = this
    
    @hit = new PIXI.Sprite(stage.tex.bubble)
    @hit.anchor = {x: 0.5, y: 0.5}
    
    @hit.alpha = 0.0
    
    @hit.scale.x = @opt.size * 4 unless @opt.display
    @hit.scale.y = @opt.size * 4 unless @opt.display
    
    @hit.interactive = true
    @hit.on 'mouseup', (evt) =>
      unless game.is.saving
        selectMandala(@genome)
      if game.is.saving
        game.is.saving = false
        name = prompt 'Enter creature name:', 'anon'
        if name?
          addGenome name, @genome.array()
          console.log 'saved'
        else
          console.log 'save canceled'
    
    @buildSprite()
    
    @sprite.addChild @hit
    
    world.add @body
    stage.ents.addChild @sprite
    game.soma.push @body
    
  buildTex: ->
    count = Math.ceil(16 * @genome.nxt())
    newTex = new PIXI.Container()
    for val in [1..count]
      scale = 0.07 + (0.6 * @genome.nxt())
      tex = @genome.nxt(stage.allTex)
      ring = new SpriteRing({
        sym: Math.ceil(9 * @genome.nxt())
        offset: (worldHeight / 4) * @genome.nxt()
        rot: 0 #Math.PI * @genome.nxt()
        origin: cen
        scale:
          x: scale, y: scale
        alpha: 0.8
        tex: tex
        tint: @genome.nxt(@palette)
      })
      newTex.addChild ring.sprite
    finalTex = new PIXI.RenderTexture(renderer.renderer, worldWidth, worldHeight)
    finalTex.render(newTex, null, true)
    return finalTex
    
  getColor: ->
    r = Math.floor(255 * @genome.nxt())
    g = Math.floor(255 * @genome.nxt())
    b = Math.floor(255 * @genome.nxt())
    color = r.toString(16) + g.toString(16) + b.toString(16)
    return '0x' + color
    
    
  buildSprite: ->
    count = Math.ceil(16 * @genome.nxt())
    shades = Math.ceil(3 * @genome.nxt())
    numTex = Math.ceil(4 * @genome.nxt())
    @palette = (@getColor() for [1..shades])
    @tex = (@buildTex() for num in [1..numTex])
    for val in [1..count]
      scale = 0.5 + (1.5 * @genome.nxt())
      tex = @genome.nxt(@tex)
      ring = new SpriteRing({
        sym: Math.ceil(9 * @genome.nxt())
        offset: (worldHeight / 2) * @genome.nxt()
        rot: 0 #Math.PI * @genome.nxt()
        scale:
          x: scale, y: scale
        alpha: 0.7
        tex: tex
        tint: @genome.nxt(@palette)
      })
      @sprite.addChild ring.sprite
      ring.animate({
        rot: @genome.nxt()
        off: @genome.nxt()
        spd: @genome.nxt()
        rev: @genome.nxt() > 0.5
      })
    
root.Soma = Soma