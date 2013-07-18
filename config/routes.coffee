exports.routes = (map)->
  map.resources 'articles'

  map.resources 'blogs'

  map.resources 'users'

  map.resources 'posts'


  # map.post "/login", passport.authenticate("local",
	 #  successRedirect: "/"
	 #  failureRedirect: "/login"
  # )



  # Generic routes. Add all your routes below this line
  # feel free to remove generic routes
  # map.all ':controller/:action'
  # map.all ':controller/:action/:id'
  map.get '/login', "users#login"  
  map.post "/login/authenticate", "users#authenticate"