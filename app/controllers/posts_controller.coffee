load 'application'

before 'load Post', ->
  Post.find params.id, (err, Post) =>
    if err || !Post
      if !err && !Post && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.posts
    else
      @Post = Post
      next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
  @Post = new Post
  @title = 'New Post'
  render()

action 'create', ->
  Post.create body.Post, (err, Post) =>
    respondTo (format) =>
      format.json ->
        if err
          send code: 500, error: Post.errors || err
        else
          send code: 200, data: Post.toObject()
      format.html =>
        if err
          flash 'error', 'Post can not be created'
          @Post = Post
          @title = 'New Post'
          render 'new'
        else
          flash 'info', 'Post created'
          redirect pathTo.posts

action 'index', ->
  Post.all (err, posts) =>
    @posts = posts
    @title = 'Post index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: posts
      format.html ->
        render posts: posts

action 'show', ->
  @title = 'Post show'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Post
    format.html ->
      render()

action 'edit', ->
  @title = 'Post edit'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Post
    format.html ->
      render()

action 'update', ->
  @Post.updateAttributes body.Post, (err) =>
    respondTo (format) =>
      format.json =>
        if err
          send code: 500, error: @Post.errors || err
        else
          send code: 200, data: @Post
      format.html =>
        if !err
          flash 'info', 'Post updated'
          redirect path_to.Post(@Post)
        else
          flash 'error', 'Post can not be updated'
          @title = 'Edit Post details'
          render 'edit'

action 'destroy', ->
  @Post.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy Post'
        else
          flash 'info', 'Post successfully removed'
        send "'" + path_to.posts + "'"
