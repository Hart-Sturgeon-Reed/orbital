root = exports ? this

class Emitter
  constructor: (@pos, @layer) ->
    @patterns = [] #effects, written as json patterns
    @activePattern = null #current pattern
    @pool = [] #object pool to store particles in
    @particles = [] #active particles (being rendered)
    @queue = [] #a list of sequential effects to play
    
  addPattern: (name, @opt) ->
    @patterns[name] = @opt
    
  nextEffect: ->
  
  playEffect: (pattern) ->
    
  createPool: ->
      
  recycle: (dead) ->
    @particles.splice @particles.indexOf(dead), 1
    @pool.push dead
    @layer.removeChild dead
    
  emit: ->
    unless @activePattern?
      console.log 'error, no pattern'
      return
    p = @pool.shift()
    p[prop] = val for prop, val of @activePattern
    p.dead = false
    @layer.addChild p
    @particles.push p
  
root.Emitter = Emitter unless root.Emitter?