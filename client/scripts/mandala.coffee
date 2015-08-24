root = exports ? this

root.buildMandalas = (genome) ->
  #for pos in getRadialSym(4, {x: cen.x, y: cen.y - worldHeight / 2.8}, cen, Math.PI/4)
  for num in [1...60]
    gen = if genome? then new Genome(genome.array()).mutate() else null
    new Soma({
      pos: 
        x: rnd(worldWidth)
        y: rnd(worldHeight)
      vel:
        x: rnd(eql:0.06)
        y: rnd(eql:0.06)
      genome: gen
      size: 4
    })
  impulse.applyTo game.soma.concat bounds.body
  if genome?
    new Soma({
      pos: cen
      genome: new Genome(genome.array())
      size: worldWidth * 0.016
      display: true
    }) 
      
root.removeMandalas = ->
  for old in game.soma
    stage.ents.removeChild old.self.sprite
  game.soma = []
  game.rings = []
  
root.displayMandala = (genome) ->
  removeMandalas()
  new Soma({
    pos: cen
    genome: new Genome(genome)
    size: worldWidth * 0.026
    display: true
  })
  
root.selectMandala = (genome) ->
  removeMandalas()
  buildMandalas genome
  
root.refreshMandalas = ->
  removeMandalas()
  buildMandalas()
  