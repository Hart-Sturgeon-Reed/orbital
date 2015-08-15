root = exports ? this

root.Collisions =
  spores: Physics.query({
    $or: [
        { bodyA: { label: 'cell' }, bodyB: { label: 'cell' } }
        { bodyB: { label: 'cell' }, bodyA: { label: 'cell' } }
    ]
  })
  
  collideSpores: (one, two) ->
    return if one.self.team == two.self.team
    one.force = one.state.old.vel.clone().norm() * one.mass
    
    two.force = two.state.old.vel.clone().norm() * two.mass
    
    [attacker, defender] = if one.force > two.force then [one, two] else [two, one]
    
    console.log attacker.force + ',' + defender.force
    
    if attacker.force > 0.5
      stage.audio.collide.setTime(0).play()
      damage = attacker.force * 20
      availEnergy = defender.self.energy
      console.log "hit for #{damage}"
      
      defender.self.hit damage if defender.self.energy - damage < 0
      defender.self.useEnergy damage * 1.5, true
      defender.state.vel.mult 1.01
      gain = if damage * 1.6 > availEnergy then availEnergy else damage * 1.6
      attacker.self.addEnergy gain
      #attacker.applyForce defender.state.vel.clone().negate().mult 0.1
    
  collide: (data) ->
    found = Physics.util.find data.collisions, @spores
    if found?
      @collideSpores found.bodyA, found.bodyB