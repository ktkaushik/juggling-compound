module.exports = 
  development:
    driver: "mongodb"
    url: process.env.MONGOLAB_URI || "mongodb://localhost/dev"

  test:
    driver: "mongodb"
    url: process.env.MONGOLAB_URI || "mongodb://localhost/dev"

  production:
    driver: "mongodb"
    url: process.env.MONGOLAB_URI || "mongodb://localhost/dev"