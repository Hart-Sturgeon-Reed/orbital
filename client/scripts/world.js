setupWorld = function(renderer){
    // create a physics world
    world = Physics({
        timestep: 1000.0 / 140
    });

    // add the renderer
    world.add( renderer );
  
    dev = 'default';
    
    console.log('Device is: '+dev);
  
    if (dev=='tablet'){
      worldWidth = stageWidth/2;
      worldHeight = stageHeight/2;
    }else if (dev=='mobile'){
      worldWidth = stageWidth/3;
      worldHeight = stageHeight/3;
      scaleFactor *= (2/3);
      courseLength *= (1.1);
      gravityStrength = GRV.mobile;
    }else{
      worldWidth = stageWidth/2;
      worldHeight = stageHeight/2;
    }
    
    var viewportBounds = Physics.aabb(0, 0, worldWidth, worldHeight);
    bounds = Physics.behavior('edge-collision-detection', {
        aabb: viewportBounds,
        restitution: 0.1,
        cof: 0.3,
        label:'bounds'
    });
    
    world.add( bounds );
  
    impulse = Physics.behavior('body-impulse-response');
    collision = Physics.behavior('body-collision-detection')
    world.add( impulse );
    world.add( collision );
    world.add(Physics.behavior('sweep-prune') );
    world.add(Physics.behavior('interactive', { el: renderer.el }));
    
    gravity = Physics.behavior('constant-acceleration', {
        acc: { x : 0, y: 0.0014 } // 0.0016 is the default // 14 normal // 10 light // 18 heavy
    });
    world.add(gravity);
    
    attractor = Physics.behavior('attractor', {
	    order: 0,
	    strength: 0.001
	});
    
    constraints = Physics.behavior('verlet-constraints', {
        iterations: 2
    });
    world.add(constraints);
    
	world.on({
//	    'interact:poke': function( pos ){
//		attractor.position( pos );
//		world.add( attractor );
//	    }
//	    ,'interact:move': function( pos ){
//		attractor.position( pos );
////            if(mouse!=null) mouse.setPos(pos);
//	    }
//	    ,'interact:release': function(){
//		world.remove( attractor );
//	    }
	});

    // render on each step
    world.on('step', function(){
        //gameLoop();
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
        //if(paused) return;
        world.step(time);
    });
  
    Physics.util.ticker.start();
}