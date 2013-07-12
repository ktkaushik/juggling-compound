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