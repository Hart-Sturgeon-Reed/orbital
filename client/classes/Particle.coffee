root = exports ? this

class Particle
  constructor: (@opt) ->
    @defaults =
      tex: stage.tex.wisp
      position: {x: 0, y: 0}
      scale: {x: 1, y: 1}
      anchor: {x: 0.5, y: 0.5}
      alpha: 1.0
      tint: 0xFF0A0D
    #fill in default values for options
    @opt[prop] ?= def for prop, def of @defaults
    
    #create the pixijs sprite
    @sprite = new PIXI.Sprite(@opt.tex)
    #add options to sprite
    @sprite[prop] = val for prop, val of @opt
  
unless root.Particle
  root.Particle = Particle