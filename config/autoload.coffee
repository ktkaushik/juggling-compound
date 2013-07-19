module.exports = (compound) ->
  # defaultModules = [
  #   'jugglingdb',
  #   'co-assets-compiler'
  # ]

  # developmentModules = []
  # if compound.app.get('env') is 'development'
  #   developmentModules = [
  #     'ejs-ext',
  #     'seedjs',
  #     'co-generators'
  #   ]

  # unless window?
  #   return defaultModules.concat(developmentModules).map(require)
  # else
  #   return []

  return if typeof window == 'undefined'  then [
    'jugglingdb',
    'co-assets-compiler'
  ].concat( if 'development' == compound.app.get('env') then [
    'ejs-ext',
    'seedjs',
    'co-generators'
  ] else [] ).map(require) else []