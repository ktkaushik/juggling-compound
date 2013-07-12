module.exports = (compound, Book) ->
  @belongsTo Library,
	  as: "library"
	  foreignKey: "libraryId"
