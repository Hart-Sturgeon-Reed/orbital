setupWorld = function(renderer){
  console.log('building world');
    // create a physics world
    world = Physics({
        timestep: 1000.0 / 140
    });
    // add the renderer
    world.add( renderer );
    
    console.log('Device is: '+dev);
  
    if (dev=='tablet'){
      worldWidth = stageWidth/2;
      worldHeight = stageHeight/2;
    }else if (dev=='mobile'){
      stage.root.scale = {
        x: 0.333,
        y: 0.333
      }
    }else{
      worldWidth = stageWidth;
      worldHeight = stageHeight;
    }
    
    var viewportBounds = Physics.aabb(0, 0, stageWidth, stageHeight);
    bounds = Physics.behavior('edge-collision-detection', {
        aabb: viewportBounds,
        restitution: 0.9,
        cof: 0.3,
        label:'bounds'
    });
    
    world.add( bounds );
  
    impulse = Physics.behavior('body-impulse-response');
    world.add( impulse );
  
    collision = Physics.behavior('body-collision-detection')
    world.add( collision );
  
    world.add(Physics.behavior('sweep-prune') );
    
    interactive = Physics.behavior('interactive', { 
      el: renderer.el, 
      minVel: {x: 0, y: 0},
      maxVel: {x: 0, y: 0},
      noDrag: true
    })
    world.add(interactive);
    
    gravity = Physics.behavior('constant-acceleration', {
        acc: { x : 0, y: 0.0014 } // 0.0016 is the default // 14 normal // 10 light // 18 heavy
    });
    //world.add(gravity);
  
    orbitalGrav = Physics.behavior('newtonian', {
        strength: 0.16,
        max: 880,
        min: 90
    });
    world.add(orbitalGrav);
    
    attractor = Physics.behavior('attractor', {
	    order: 0,
	    strength: 0.0001
	});
    
    constraints = Physics.behavior('verlet-constraints', {
        iterations: 2
    });
    world.add(constraints);
    
	world.on({
      'interact:grab': function( data ){
        input.startGrab(data);
      }
      ,'interact:poke': function( data ){
        //attractor.position( pos );
        //world.add( attractor );
      }
      ,'interact:move': function( data ){
        //attractor.position( pos );
//      if(mouse!=null) mouse.setPos(pos);
        input.onMove(data);
      }
      ,'interact:release': function( data ){
        input.endGrab(data);
      }
	});

    // render on each step
    world.on('step', function(){
        world.render();
    });
    
    world.on('integrate:positions', function(){
        //player.update();
    });
    
    world.on('integrate:velocities', function(){
        
    });
  
    world.on('collisions:detected', function( data, e ){
      //processCollisions(data,e);
    });
    
    Physics.util.ticker.on(function(time){
        if(game.is.paused) {world.render(); return;}
        gameLoop(time);
        world.step(time);
    });
  
    world.warp(0.2); //set time to 1/10 speed
    
    setupInput();
    startGame({x: worldWidth/2, y: worldHeight/2});
}