Post = describe 'Post', ->
    property 'title', String
    set 'restPath', pathTo.Posts

User = describe 'User', ->
    property 'name', String
    property 'email', String
    property 'password', String
    property 'hashed_password', String
    property 'salt', String
    property 'facebook', String
    property 'twitter', String
    property 'github', String
    set 'restPath', pathTo.users

Blog = describe 'Blog', ->
    property 'title', String
    property 'desc', String
    set 'restPath', pathTo.Blogs

Library = describe 'Library', ->
    property 'name', String
    set 'restPath', pathTo.libraries

Book = describe 'Book', ->
    property 'name', String
    property 'author', String
    set 'restPath', pathTo.books

Administrator = describe 'Administrator', ->
    property 'name', String
    set 'restPath', pathTo.administrators

User = describe 'User', ->
    property 'name', String
    property 'email', String
    set 'restPath', pathTo.users

Blog = describe 'Blog', ->
    property 'name', String
    property 'email', String
    set 'restPath', pathTo.Blogs

Article = describe 'Article', ->
    property 'name', String
    set 'restPath', pathTo.Articles

