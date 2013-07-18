var app, compound
, request = require('supertest')
, sinon   = require('sinon');

function BlogStub () {
    return {
        name: '',
        email: ''
    };
}

describe('BlogController', function() {
    beforeEach(function(done) {
        app = getApp();
        compound = app.compound;
        compound.on('ready', function() {
            done();
        });
    });

    /*
     * GET /blogs/new
     * Should render blogs/new.ejs
     */
    it('should render "new" template on GET /blogs/new', function (done) {
        request(app)
        .get('/blogs/new')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didRender(/blogs\/new\.ejs$/i).should.be.true;
            done();
        });
    });

    /*
     * GET /blogs
     * Should render blogs/index.ejs
     */
    it('should render "index" template on GET /blogs', function (done) {
        request(app)
        .get('/blogs')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didRender(/blogs\/index\.ejs$/i).should.be.true;
            done();
        });
    });

    /*
     * GET /blogs/:id/edit
     * Should access Blog#find and render blogs/edit.ejs
     */
    it('should access Blog#find and render "edit" template on GET /blogs/:id/edit', function (done) {
        var Blog = app.models.Blog;

        // Mock Blog#find
        Blog.find = sinon.spy(function (id, callback) {
            callback(null, new Blog);
        });

        request(app)
        .get('/blogs/42/edit')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Blog.find.calledWith('42').should.be.true;
            app.didRender(/blogs\/edit\.ejs$/i).should.be.true;

            done();
        });
    });

    /*
     * GET /blogs/:id
     * Should render blogs/index.ejs
     */
    it('should access Blog#find and render "show" template on GET /blogs/:id', function (done) {
        var Blog = app.models.Blog;

        // Mock Blog#find
        Blog.find = sinon.spy(function (id, callback) {
            callback(null, new Blog);
        });

        request(app)
        .get('/blogs/42')
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Blog.find.calledWith('42').should.be.true;
            app.didRender(/blogs\/show\.ejs$/i).should.be.true;

            done();
        });
    });

    /*
     * POST /blogs
     * Should access Blog#create when Blog is valid
     */
    it('should access Blog#create on POST /blogs with a valid Blog', function (done) {
        var Blog = app.models.Blog
        , blog = new BlogStub;

        // Mock Blog#create
        Blog.create = sinon.spy(function (data, callback) {
            callback(null, blog);
        });

        request(app)
        .post('/blogs')
        .send({ "Blog": blog })
        .end(function (err, res) {
            res.statusCode.should.equal(302);
            Blog.create.calledWith(blog).should.be.true;

            done();
        });
    });

    /*
     * POST /blogs
     * Should fail when Blog is invalid
     */
    it('should fail on POST /blogs when Blog#create returns an error', function (done) {
        var Blog = app.models.Blog
        , blog = new BlogStub;

        // Mock Blog#create
        Blog.create = sinon.spy(function (data, callback) {
            callback(new Error, blog);
        });

        request(app)
        .post('/blogs')
        .send({ "Blog": blog })
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            Blog.create.calledWith(blog).should.be.true;

            app.didFlash('error').should.be.true;

            done();
        });
    });

    /*
     * PUT /blogs/:id
     * Should redirect back to /blogs when Blog is valid
     */
    it('should redirect on PUT /blogs/:id with a valid Blog', function (done) {
        var Blog = app.models.Blog
        , blog = new BlogStub;

        Blog.find = sinon.spy(function (id, callback) {
            callback(null, {
                id: 1,
                updateAttributes: function (data, cb) { cb(null) }
            });
        });

        request(app)
        .put('/blogs/1')
        .send({ "Blog": blog })
        .end(function (err, res) {
            res.statusCode.should.equal(302);
            res.header['location'].should.include('/blogs/1');

            app.didFlash('error').should.be.false;

            done();
        });
    });

    /*
     * PUT /blogs/:id
     * Should not redirect when Blog is invalid
     */
    it('should fail / not redirect on PUT /blogs/:id with an invalid Blog', function (done) {
        var Blog = app.models.Blog
        , blog = new BlogStub;

        Blog.find = sinon.spy(function (id, callback) {
            callback(null, {
                id: 1,
                updateAttributes: function (data, cb) { cb(new Error) }
            });
        });

        request(app)
        .put('/blogs/1')
        .send({ "Blog": blog })
        .end(function (err, res) {
            res.statusCode.should.equal(200);
            app.didFlash('error').should.be.true;

            done();
        });
    });

    /*
     * DELETE /blogs/:id
     * -- TODO: IMPLEMENT --
     */
    it('should delete a Blog on DELETE /blogs/:id');

    /*
     * DELETE /blogs/:id
     * -- TODO: IMPLEMENT FAILURE --
     */
    it('should not delete a Blog on DELETE /blogs/:id if it fails');
});
