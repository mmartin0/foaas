
module.exports = (app) ->

  app.get '/operations', (req, res) ->
    res.send [
      { name: "Fuck You", url: '/you/:name/:from', fields: [
        { name: 'Name', field: 'name'}
        { name: 'From', field: 'from'}
      ] }
    ]
