root = exports ? this

class Particle
  constructor: (@opt) ->
    @opt.tex ?= stage.tex.wisp
    @opt.pos ?= {x: 0, y: 0}
    @opt.scale ?= {x: 1, y: 1}
    @opt.anchor ?= {x: 0.5, y: 0.5}
    @opt.alpha ?= 1.0
    @opt.tint ?= 0xFF0A0D
    
    @sprite = new PIXI.Sprite(@opt.tex)
    @sprite.alpha = @opt.alpha
    @sprite.tint = @opt.tint
    @sprite.scale.x = @opt.scale.x
    @sprite.scale.y = @opt.scale.y
    @sprite.anchor.x = @opt.anchor.x
    @sprite.anchor.y = @opt.anchor.y
    @sprite.position.x = @opt.pos.x
    @sprite.position.y = @opt.pos.y 
  
unless root.Particle
  root.Particle = Particle