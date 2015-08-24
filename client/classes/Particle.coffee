root = exports ? this

class Particle
  constructor: (@opt) ->
    life = if dev =='mobile' then worldWidth * 0.2 else worldWidth * 0.3
    @defaults =
      tex: stage.tex.wisp
      sprite: null
      position: {x: 0, y: 0}
      vel: {x: 0, y: 0}
      scale: {x: 1, y: 1}
      anchor: {x: 0.5, y: 0.5}
      lifetime: life
      alpha: 1.0
      tint: 0xFF0A0D
      mode: 'normal'
      blendMode: PIXI.BLEND_MODES.NORMAL
      speed: 1.4
      dead: false
    
    #fill in default values for options
    @opt[prop] ?= def for prop, def of @defaults
    @opt.position = @opt.pos if @opt.pos?
    
    #create the pixijs sprite
    switch @opt.sprite
      when null
        @sprite = new PIXI.Sprite(@opt.tex)
      else
        tex = new PIXI.RenderTexture(renderer.renderer, worldWidth, worldHeight)
        tex.render(@opt.sprite)
        @sprite = new PIXI.Sprite(tex)
    
    #add options to sprite
    @sprite[prop] = val for prop, val of @opt
    @sprite.age = @sprite.lifetime
    
    @update = ->
      return if @sprite.dead
      @sprite.position.x += @sprite.vel.x
      @sprite.position.y += @sprite.vel.y
      pos = Physics.vector @sprite.position.x, @sprite.position.y
      @sprite.age--
      @sprite.alpha = @opt.alpha * (@sprite.age / @sprite.lifetime)
      @sprite.dead = true if @sprite.age < 0
      switch @opt.mode
        when 'follow'
          targetPos = @sprite.target.state.pos.clone()
          vector = targetPos.vsub(pos)
          dist = vector.clone().norm()
          if dist < @sprite.target.radius * 0.8 and @sprite.dead is false
            stage.flares.removeChild @sprite
            @sprite.dead = true
            @sprite.age = -1
            @sprite.target.self.addEnergy @sprite.energy, true
          correctVel = vector.clone().normalize().mult(@sprite.speed)
          @sprite.vel.x += (correctVel.x - @sprite.vel.x)/12
          @sprite.vel.y += (correctVel.y - @sprite.vel.y)/12
          
  
unless root.Particle
  root.Particle = Particle
  
#function Particle(system,pool){
#  var self = this;
#  this.pool = pool;
#  this.sprite = new PIXI.Sprite(system.particleSprite);
#  this.sprite.anchor = {
#      x: 0.5,
#      y: 0.5
#  };
#  this.new = true;
#  this.sprite.blendMode = PIXI.blendModes.SCREEN;
#  this.sprite.tint = system.particleTint;
#  var scale = range(system.particleSize.min,system.particleSize.max);
#  this.sprite.width = scale;
#  this.sprite.height = scale;
#  this.opacity = system.particleOpacity;
#  this.sprite.alpha = this.opacity;
#
#  this.currentSprite = system.particleSprite;
#
#  this.lifespan = system.particleLifespan;
#  this.gravity = system.gravity;
#  this.age = 0;
#
#  this.vx = equalDist(system.particleSpeed);
#  this.vy = equalDist(system.particleSpeed);
#
#  this.generateSprite = function(){
#      this.sprite.setTexture(system.particleSprite);
#      this.sprite.tint = system.particleTint;
#      this.currentSprite = system.particleSprite;
#  };
#  this.update = function(){
#      if(this.age>this.lifespan){
#          this.dead = true;
#      }else if(this.sprite.visible){
#          //console.log(this.vy);
#          this.age++;
#          this.sprite.alpha = (1 - this.age/this.lifespan)*self.opacity;
#          this.sprite.position.x += this.vx;
#          this.sprite.position.y += this.vy;
#          this.sprite.position.y += this.gravity;
#      }
#  };
#  this.reset = function(){
#      this.new = false;
#      this.sprite.visible = false;
#      this.age = 0;
#      this.sprite.alpha = self.opacity;
#      this.dead = false;
#  };
#  this.init = function(){
#      if(this.currentSprite != system.particleSprite || this.sprite.tint != system.particleTint){
#          this.generateSprite();
#      }
#      this.sprite.visible = true;
#      this.lifespan = system.particleLifespan;
#      this.gravity = system.gravity;
#      this.vx = equalDist(system.particleSpeed);
#      this.vy = equalDist(system.particleSpeed);
#
#  };
#  this.setPosition = function(xPos,yPos){
#      this.sprite.position = {x:xPos + equalDist(system.particleSpread),y:yPos + equalDist(system.particleSpread)};
#  }
#}