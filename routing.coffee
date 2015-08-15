Router.route '/', { # Root
    #loadingTemplate: 'loader' if necessary
    action: ->
      id = this.params._id
      this.layout 'layout'
      this.render 'main', {
        to: 'content'
      }
    onAfterAction: ->
      console.log Iron.Location.get().path
  }