window.setupStage = ->
    window.stageWidth = window.innerWidth
    window.stageHeight = window.innerHeight
    window.worldWidth = stageWidth
    window.worldHeight = stageHeight
    window.cen =
      x: worldWidth / 2
      y: worldHeight / 2
    
    console.log "New canvas #{stageWidth} wide and #{stageHeight} tall"
    
    renderer = Physics.renderer('pixi', {
        el: 'game-canvas'
        meta: false
        styles:
          'color': '0x2C75B9'
    })

    renderer.resize(stageWidth,stageHeight)
    
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
      
      #setup layers and ui
      stage['root'] = new PIXI.Container()
      stage.root.scale.x -= 0.5
      stage.root.scale.y -= 0.5
      stage.addChild stage.root
      
      addLayer 'ents'
      addLayer 'ui'
      
      setupWorld renderer
    
    #Start loading resources
    PIXI.loader.load()
    
addLayer = (name) ->
  stage[name] = new PIXI.Container()
  stage.root.addChild stage[name]