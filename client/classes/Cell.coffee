root = exports ? this

class Cell
  constructor: (xpos, ypos) ->
    options =
        mass: 0.1
        type: 'circle'
        sprite: stage.tex.bubble
        radius: scale
        hitBox: {radius:0.6}
        angle: 0
        friction: 0.1
        restitution: 0.9
        pos: {x:xposy:ypos}
        label: 'cell'
    Ent.call(this, options)

    @body.self = self
    @body.follow = player
    @body.parallax = 1


    world.add @body
    stage.ents.addChild @sprite
    cells.push @body
    
root.Cell = Cell