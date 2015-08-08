if Meteor.isClient
  console.log 'Server started successfully'
  
  Session.setDefault 'clicks', 0
  
  Template.main.helpers
    counter: -> Session.get 'clicks'
  Template.main.events
    'click .inc': (event) ->
      console.log 'quak'
      Session.set 'clicks', (Session.get('clicks') + 1)
      
  
  window.setupStage = ->
    stageWidth = window.screen.availWidth
    stageHeight = window.screen.availHeight
    cen =
      x: stageWidth / 2
      y: stageHeight / 2
    
    console.log "New canvas #{stageWidth} wide and #{stageHeight} tall"
    
    renderer = PIXI.autoDetectRenderer(stageWidth, stageHeight, {backgroundColor : 0x000})
    document.body.appendChild(renderer.view)
    stage = window.stage = new PIXI.Container()
    
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
      rad = window.getRadialSym
      for cen in rad(6, {x: cen.x - 430, y: cen.y}, {x: cen.x , y: cen.y}, Math.PI/2)
        for pos in rad(6, {x: cen.x + 220, y: cen.y}, {x: cen.x, y: cen.y})
          sphere = new PIXI.Sprite(stage.tex.bubble)
          sphere.tint =  0xFF0A0D
          sphere.alpha = 0.4
          sphere.scale.x -= 0.1
          sphere.scale.y -= 0.1
          sphere.anchor.x = sphere.anchor.y = 0.5
          sphere.position.x = pos.x
          sphere.position.y = pos.y

          stage.addChild sphere
      
      stage.animate()
    
    stage.animate = ->
      renderer.render stage
      requestAnimationFrame stage.animate
    
    #Start loading resources
    PIXI.loader.load()
    
  
