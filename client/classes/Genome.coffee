root = exports ? this

class Gene
  constructor: (@val = rnd()) ->
  
  mutate: (opt = {}) ->
    if rnd() > 0.14
      @val += rnd {eql: 0.22}
      @val = clamp @val, 0, 1
    else
      return @val

root.Genome = class Genome
  constructor: (genome) ->
    @length = 32
    @current = 0
    if genome?
      @genes = (new Gene(val) for val in genome)
    else 
      @genes = []
      for val in [1..@length]
        @genes.push new Gene()
    #console.dir @genes
  get: (num) ->
    @genes[num].val
  nxt: (choices) ->
    if choices?
      #console.log 'hello'
      val = choices[Math.floor(choices.length * @genes[@current].val)]
    else
      val = @genes[@current].val
    @current++
    if @current == @genes.length then @current = 0
    return val
  array: ->
    return (gene.val for gene in @genes)
  mutate: ->
    newGenes = (gene.mutate() for gene in @genes)
    @genes = []
    for gene in newGenes
      @genes.push new Gene(gene)
    @current = 0
    return this
     