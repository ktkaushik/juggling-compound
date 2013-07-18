var app, compound
, request = require('supertest')
, sinon   = require('sinon');

function ArticleStub () {
    return {
        name: ''
    };
}

describe('ArticleController', function() {
    beforeEach(function(done) {
        app = getApp();
        compound = app.compound;
        compound.on('ready', function() {
            done();
        });
    });

    /*
     * GET /articles/new
     * Should render articles/new.ejs
     */
    it('should render "new" template on GET /articles/new', function (done) {
        request(app)
        .get('/articles/new')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didRender(/articles\/new\.ejs$/i).should.be.true;
            done();
        });
    });

    /*
     * GET /articles
     * Should render articles/index.ejs
     */
    it('should render "index" template on GET /articles', function (done) {
        request(app)
        .get('/articles')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didRender(/articles\/index\.ejs$/i).should.be.true;
            done();
        });
    });

    /*
     * GET /articles/:id/edit
     * Should access Article#find and render articles/edit.ejs
     */
    it('should access Article#find and render "edit" template on GET /articles/:id/edit', function (done) {
        var Article = app.models.Article;

        // Mock Article#find
        Article.find = sinon.spy(function (id, callback) {
            callback(null, new Article);
        });

        request(app)
        .get('/articles/42/edit')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Article.find.calledWith('42').should.be.true;
            app.didRender(/articles\/edit\.ejs$/i).should.be.true;

            done();
        });
    });

    /*
     * GET /articles/:id
     * Should render articles/index.ejs
     */
    it('should access Article#find and render "show" template on GET /articles/:id', function (done) {
        var Article = app.models.Article;

        // Mock Article#find
        Article.find = sinon.spy(function (id, callback) {
            callback(null, new Article);
        });

        request(app)
        .get('/articles/42')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Article.find.calledWith('42').should.be.true;
            app.didRender(/articles\/show\.ejs$/i).should.be.true;

            done();
        });
    });

    /*
     * POST /articles
     * Should access Article#create when Article is valid
     */
    it('should access Article#create on POST /articles with a valid Article', function (done) {
        var Article = app.models.Article
        , article = new ArticleStub;

        // Mock Article#create
        Article.create = sinon.spy(function (data, callback) {
            callback(null, article);
        });

        request(app)
        .post('/articles')
        .send({ "Article": article })
        .end(function (err, res) {
            res.statusCode.should.equal(302);
            Article.create.calledWith(article).should.be.true;

            done();
        });
    });

    /*
     * POST /articles
     * Should fail when Article is invalid
     */
    it('should fail on POST /articles when Article#create returns an error', function (done) {
        var Article = app.models.Article
        , article = new ArticleStub;

        // Mock Article#create
        Article.create = sinon.spy(function (data, callback) {
            callback(new Error, article);
        });

        request(app)
        .post('/articles')
        .send({ "Article": article })
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Article.create.calledWith(article).should.be.true;

            app.didFlash('error').should.be.true;

            done();
        });
    });

    /*
     * PUT /articles/:id
     * Should redirect back to /articles when Article is valid
     */
    it('should redirect on PUT /articles/:id with a valid Article', function (done) {
        var Article = app.models.Article
        , article = new ArticleStub;

        Article.find = sinon.spy(function (id, callback) {
            callback(null, {
                id: 1,
                updateAttributes: function (data, cb) { cb(null) }
            });
        });

        request(app)
        .put('/articles/1')
        .send({ "Article": article })
        .end(function (err, res) {
            res.statusCode.should.equal(302);
            res.header['location'].should.include('/articles/1');

            app.didFlash('error').should.be.false;

            done();
        });
    });

    /*
     * PUT /articles/:id
     * Should not redirect when Article is invalid
     */
    it('should fail / not redirect on PUT /articles/:id with an invalid Article', function (done) {
        var Article = app.models.Article
        , article = new ArticleStub;

        Article.find = sinon.spy(function (id, callback) {
            callback(null, {
                id: 1,
                updateAttributes: function (data, cb) { cb(new Error) }
            });
        });

        request(app)
        .put('/articles/1')
        .send({ "Article": article })
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didFlash('error').should.be.true;

            done();
        });
    });

    /*
     * DELETE /articles/:id
     * -- TODO: IMPLEMENT --
     */
    it('should delete a Article on DELETE /articles/:id');

    /*
     * DELETE /articles/:id
     * -- TODO: IMPLEMENT FAILURE --
     */
    it('should not delete a Article on DELETE /articles/:id if it fails');
});
