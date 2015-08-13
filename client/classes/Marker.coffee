root = exports ? this

class Marker
  constructor: ->
    Particle.call this, {
      pos: cen
      scale:
        x: 0.1
        y: 0.1
      tint: 0xFFFFFF
    }
  
  
root.Marker = Marker unless root.Marker?