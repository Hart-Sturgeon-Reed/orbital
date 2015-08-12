window.setupStage = ->
    window.stageWidth = window.innerWidth
    window.stageHeight = window.innerHeight
    window.worldWidth = stageWidth/2
    window.worldHeight = stageHeight/2
    cen =
      x: worldWidth / 2
      y: worldHeight / 2
    
    console.log "New canvas #{stageWidth} wide and #{stageHeight} tall"
    
    renderer = Physics.renderer('pixi', {
        el: 'game-canvas'
        meta: false
    })

    renderer.resize(stageWidth,stageHeight);
    
    stage = window.stage = renderer.stage
    
    PIXI.loader
      .add('wisp', 'sprites/spheres/wispLt.png')
      .add('bubble', 'sprites/spheres/bubbleLt.png')
      .once('complete', (loader, resources) ->
        console.log 'assets loaded'
        stage.tex =
          wisp : resources.wisp.texture
          bubble : resources.bubble.texture
        stage.ready()
      )
    
    stage.ready = ->
      console.log 'building scene'
      rad = getRadialSym
      for cen in rad(6, {x: cen.x + 110, y: cen.y}, {x: cen.x , y: cen.y}, Math.PI/2)
        for pos in rad(6, {x: cen.x + 80, y: cen.y}, {x: cen.x, y: cen.y})
          sphere = new Particle({
            tex: stage.tex.bubble 
            position: pos
            scale: {x: 0.6, y: 0.6}
            alpha: 0.2
          })

          stage.addChild sphere.sprite
      
      setupWorld renderer
    
    #Start loading resources
    PIXI.loader.load()