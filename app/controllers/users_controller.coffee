load 'application'

action 'login', ->
  render()

action 'authenticate', ->
  console.log req