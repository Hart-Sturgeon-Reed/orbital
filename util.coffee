globe = exports ? this
unless globe.getRadialSym? 
  globe.getRadialSym = (sym, root, origin, rotation) ->
    points = []
    if(sym==0) 
      return points
    root = new Physics.vector(root.x,root.y)
    origin = new Physics.vector(origin.x,origin.y)
    if rotation? 
      root = root.rotate(rotation,origin).clone()
    shift = (2*Math.PI)/sym
    points.push root.clone()
    for i in [1...sym]
        points.push root.rotate(shift, origin).clone()
    return points