load 'application'

before 'load Blog', ->
  Blog.find params.id, (err, Blog) =>
    if err || !Blog
      if !err && !Blog && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.blogs
    else
      @Blog = Blog
      next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
  @Blog = new Blog
  @title = 'New Blog'
  render()

action 'create', ->
  Blog.create body.Blog, (err, Blog) =>
    respondTo (format) =>
      format.json ->
        if err
          send code: 500, error: Blog.errors || err
        else
          send code: 200, data: Blog.toObject()
      format.html =>
        if err
          flash 'error', 'Blog can not be created'
          @Blog = Blog
          @title = 'New Blog'
          render 'new'
        else
          flash 'info', 'Blog created'
          redirect pathTo.blogs

action 'index', ->
  Blog.all (err, blogs) =>
    @blogs = blogs
    @title = 'Blog index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: blogs
      format.html ->
        render blogs: blogs

action 'show', ->
  @title = 'Blog show'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Blog
    format.html ->
      render()

action 'edit', ->
  @title = 'Blog edit'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Blog
    format.html ->
      render()

action 'update', ->
  @Blog.updateAttributes body.Blog, (err) =>
    respondTo (format) =>
      format.json =>
        if err
          send code: 500, error: @Blog.errors || err
        else
          send code: 200, data: @Blog
      format.html =>
        if !err
          flash 'info', 'Blog updated'
          redirect path_to.Blog(@Blog)
        else
          flash 'error', 'Blog can not be updated'
          @title = 'Edit Blog details'
          render 'edit'

action 'destroy', ->
  @Blog.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy Blog'
        else
          flash 'info', 'Blog successfully removed'
        send "'" + path_to.blogs + "'"
