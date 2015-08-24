Genomes = new Mongo.Collection('genomes')

if Meteor.isClient
  console.log 'Server started successfully'
  
  Meteor.subscribe 'genomes'
  
  window.screen.orientation?.lock?('landscape-primary')
  
  #  window.onresize = ->
  #    stageWidth = window.innerWidth;
  #    stageHeight = window.innerHeight;
  #    renderer.resize(stageWidth,stageHeight);
  
  if window.matchMedia('(max-device-width: 880px)').matches
    dev = 'mobile'
  else if window.matchMedia('(max-device-width: 960px)').matches
    dev = 'tablet'
  else
    dev = 'large'
    
  window.dev = dev
  
  window.addGenome = (name, genome) ->
    Genomes.insert({
      name: name
      genome: genome
    })
  
  window.getGenome = (name) ->
    if name?
      return Genomes.findOne({name: name}).genome
    else
      return Genomes.findOne({}).genome
      
  $(document).on 'keyup', input.keyPressed
  
  Template.main.helpers
    counter: -> Session.get 'clicks'
  Template.main.events
    'click .inc': (event) ->
      console.log 'quak'
      Session.set 'clicks', (Session.get('clicks') + 1)
  Template.main.rendered = ->
    setupStage()
    #$('#game-canvas').hammer()
    
  
