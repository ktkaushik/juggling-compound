module.exports = (compound, Article) ->
  # Article.validatesLengthOf 'name', min: 3, max: 10, allowNull: true
  Article.validatesNumericalityOf 'name', int: true