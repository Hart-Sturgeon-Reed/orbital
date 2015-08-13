if Meteor.isClient
  console.log 'Server started successfully'
  
  window.screen.orientation?.lock?('landscape-primary')
  
  if window.matchMedia('(max-device-width: 880px)').matches
    dev = 'mobile'
  else if window.matchMedia('(max-device-width: 960px)').matches
    dev = 'tablet'
  else
    dev = 'large'
    
  window.dev = dev
  
  Session.setDefault 'clicks', 0
  
  Template.main.helpers
    counter: -> Session.get 'clicks'
  Template.main.events
    'click .inc': (event) ->
      console.log 'quak'
      Session.set 'clicks', (Session.get('clicks') + 1)
    
  
