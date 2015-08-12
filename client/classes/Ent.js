Ent = function(options){
    var self = this;
    if (options==null) options = {};
    if (options.type==null) options.type = 'circle';
    if (options.mass==null) options.mass = 1;
    if (options.pos==null) options.pos = {x:Math.random()*stageWidth,y:Math.random()*stageHeight};
    if (options.vel==null) options.vel = {x:0,y:0};
    if (options.type=='circle'){
        if (options.radius==null) options.radius = 5;
        if (options.scale==null) options.scale = options.radius*2;
        options.width = options.height = options.scale;
    }else if (options.type=='rectangle'){
        if (options.width==null) options.width = 5;
        if (options.height==null) options.height = 5;
        if (options.scale==null) options.scale = options.width;
    }
    if (options.restitution==null) options.restitution = 0.9;
    if (options.friction==null) options.friction = 0.2;
    if (options.angle==null) options.angle = Math.random();
    if (options.sprite==null) options.sprite = sprites.bubLt;
    if (options.blendMode==null) options.blendMode = PIXI.BLEND_MODES.NORMAL;
    if (options.anchor==null) options.anchor = {x:0.5,y:0.5};
    if (options.tint==null) {
        options.tint = colors.white;
    }else if (options.tint=='random') {
        options.tint = getRandomProperty(colors);
    }
    if (options.alpha==null) options.alpha = 1;
    if (options.label==null) options.label = 'default';
    if (options.treatment==null) options.treatment = 'dynamic';
    if (options.hitBox==null) options.hitBox = {x:1,y:1,radius:1};
    if (options.flip==null) options.flip = {x:1,y:1};
    
    this.body = Physics.body(options.type, {
        x: options.pos.x, // x-coordinate
        y: options.pos.y, // y-coordinate
        vx: options.vel.x, // velocity in x-direction
        vy: options.vel.y, // velocity in y-direction,
        radius: options.radius*options.hitBox.radius,
        width: options.width*options.hitBox.x,
        height: options.height*options.hitBox.y,
        restitution: options.restitution,
        cof: options.friction,
        mass: options.mass,
        angle: options.angle,
        label: options.label,
        treatment: options.treatment
    });
    
    this.body.view = new PIXI.Sprite(options.sprite);
    this.sprite = this.body.view;
    this.sprite.blendMode = options.blendMode;
    this.sprite.anchor = options.anchor;
    this.spriteScale = options.scale;
    if (options.type=='circle'){
        this.sprite.width = options.scale;
        this.sprite.height = options.scale;
    }else if (options.type=='rectangle'){
        this.sprite.width = options.width;
        this.sprite.height = options.height;
    }
    this.sprite.width *= options.flip.x;
    this.sprite.height *= options.flip.y;
    this.sprite.tint = options.tint;
    this.sprite.alpha = options.alpha;
    
    this.setScale = function(newScale, scaleY){
        if(scaleY==null){
            self.sprite.width = self.spriteScale * newScale;
            self.sprite.height = self.spriteScale * newScale;
        }else{
            self.sprite.width = self.spriteScale * newScale;
            self.sprite.height = self.spriteScale * scaleY;
        }
        self.body.geometry.radius = self.sprite.width;
        self.body.geometry.width = self.sprite.width;
        self.body.geometry.height = self.sprite.height;
        self.body.recalc();
    }
    this.setMass = function(newMass){
        self.body.mass = newMass;
        self.body.recalc();
    }
}