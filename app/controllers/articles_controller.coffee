load 'application'

before 'load Article', ->
  Article.find params.id, (err, Article) =>
    if err || !Article
      if !err && !Article && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.articles
    else
      # console.log "******************************************* article found ***********************************************"
      # console.log Article
      @Article = Article
      @article = Article
      next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
  @article = new Article
  @title = 'New Article'
  render()

action 'create', ->
  Article.create body.Article, (err, Article) =>
    respondTo (format) =>
      format.json ->
        if err
          send code: 500, error: Article.errors || err
        else
          send code: 200, data: Article.toObject()
      format.html =>
        if err
          flash 'error', 'Article can not be created'
          @Article = Article
          @title = 'New Article'
          render 'new'
        else
          flash 'info', 'Article created'
          redirect pathTo.articles

action 'index', ->
  Article.all (err, articles) =>
    @articles = articles
    @title = 'Article index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: articles
      format.html ->
        render articles: articles

action 'show', ->
  @title = 'Article show'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Article
    format.html ->
      render()

action 'edit', ->
  @title = 'Article edit'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @Article
    format.html ->
      render()

action 'update', ->
  @Article.updateAttributes body.Article, (err) =>
    respondTo (format) =>
      format.json =>
        if err
          send code: 500, error: @Article.errors || err
        else
          send code: 200, data: @Article
      format.html =>
        # console.log "************************* in html respond ***************************"
        if !err
          # console.log "************************* no err in html ***************************"
          flash 'info', 'Article updated'
          redirect path_to.article(@Article)
        else
          # console.log "************************* err in html ***************************"
          flash 'error', 'Article can not be updated'
          @title = 'Edit Article details'
          render 'edit'

action 'destroy', ->
  @Article.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy Article'
        else
          flash 'info', 'Article successfully removed'
        send "'" + path_to.articles + "'"
