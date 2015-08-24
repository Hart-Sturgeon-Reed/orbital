util = exports ? this

#Returns an array of points with radial symmetry around an origin point
util.getRadialSym = (sym, root, origin, rotation) ->
  points = []
  if sym == 0
    return points
  else if sym == 1
    points.push origin
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

#Returns a random number with several options
util.rnd = (opt) ->
  #Return a float from 0 to 1 if called with no arguments
  return Math.random() unless opt?
  if typeof opt is 'object'
    #If called with an eql argument, return a number between -eql and +eql
    return (Math.random() * opt.eql) - (opt.eql / 2) if opt.eql?
    #If called with a range, return a number between min and max
    return opt.min + Math.random() * (opt.max - opt.min) if opt.min? and opt.max?
  else
    #Otherwise return a number between 0 and the argument
    return Math.random() * opt 

#Apply default values to an options object
util.applyDefaults = (options, defaults) ->
  options[prop] ?= val for prop, val of defaults
  
util.clamp = (val, min, max) ->
  if val < min
    return min
  else if val > max
    return max
  else return val

#Grab a random property
util.pick = (choices) ->
  num = 0
  i = 0
  num++ for own prop, choice of choices
  for own prop, choice of choices
    i++
    chance = i / num
    return choice if rnd() < chance