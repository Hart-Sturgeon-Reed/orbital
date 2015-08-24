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
    window.renderer = renderer
    
    stage = window.stage = renderer.stage
    
    stage.audio = 
      title: new buzz.sound('sounds/title', {formats: ['mp3', 'ogg']}).load()
      active: new buzz.sound('sounds/active', {formats: ['mp3', 'ogg']}).load()
      passive: new buzz.sound('sounds/passive', {formats: ['mp3', 'ogg']}).load()
      launch: new buzz.sound('sounds/launch', {formats: ['mp3', 'ogg']}).setVolume(50).load()
      destroy: new buzz.sound('sounds/destroy', {formats: ['mp3', 'ogg']}).load()
      collide: new buzz.sound('sounds/collide', {formats: ['mp3', 'ogg']}).setVolume(60).load()
    
    PIXI.loader
      .add('wisp', 'sprites/spheres/wispLt.png')
      .add('wispMd', 'sprites/spheres/wispMd.png')
      .add('wispDk', 'sprites/spheres/wisp.png')
      .add('bubble', 'sprites/spheres/bubbleLt.png')
      .add('bubbleDk', 'sprites/spheres/bubbleDk.png')
      .add('cell', 'sprites/spheres/cell.png')
      .add('planet', 'sprites/spheres/planet.png')
      .add('sphereLt', 'sprites/spheres/sphereLt.png')
      .add('sphereMd', 'sprites/spheres/sphereMd.png')
      .add('sphereDk', 'sprites/spheres/sphereDk.png')
      .once('complete', (loader, resources) ->
        console.log 'assets loaded'
        stage.tex = {}
        stage.allTex = []
        for label, res of resources
          stage.tex[label] = res.texture
          stage.allTex.push res.texture
        stage.ready()
      )
    
    stage.ready = ->
      console.log 'building scene'
      
      #setup layers and ui
      stage['root'] = new PIXI.Container()
      stage.root.scale.x -= 0.5
      stage.root.scale.y -= 0.5
      stage.addChild stage.root
      
      addLayer 'flares'
      addLayer 'ents'
      addLayer 'suns'
      addLayer 'ui'
      
      setupWorld renderer
    
    #Start loading resources
    PIXI.loader.load()
    
addLayer = (name) ->
  stage[name] = new PIXI.Container()
  stage.root.addChild stage[name]