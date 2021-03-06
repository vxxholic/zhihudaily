express = require "express"
path = require "path"
favicon = require "static-favicon"
logger = require "morgan"
bodyParser = require "body-parser"
app = express()

app.set "views", path.join __dirname, "views"
app.set "view engine", "jade"
app.use logger "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use favicon path.join(__dirname, "/public/img/", "favicon.ico")
app.use express.static path.join(__dirname, "public")

app.use "/", require "./routes/index"
app.use "/day", require "./routes/day"
app.use "/story", require "./routes/story"
app.use "/section", require "./routes/section"
app.use "/rss", require "./routes/rss"

app.use "/sections", require "./routes/section"
app.use "/index.php", require "./routes/index"
app.use "/rss.xml", require "./routes/rss"
module.exports = app