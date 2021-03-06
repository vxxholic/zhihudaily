express = require "express"
config = require "../config"
async = require "async"
Daily = require "../model/daily"
Section = require "../model/section"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/"
, (req, res, next) ->
  if config.redis.switch
    cache.route()(req, res, next)
  else
    next()
, (req, res) ->
  Section.all (err, sectionsArr)->
    sectionsArr_new = []
    for section in sectionsArr
      if section._id.title and section.count > 4
        sectionsArr_new.push
          url: "/section/" + encodeURIComponent(section._id.title)
          image: section.images[Math.floor(Math.random()*section.images.length)]
          title: section._id.title
    time = Date.now() - res.socket._idleStart
    res.render "day",
      section_title: "专题"
      storys: sectionsArr_new
      time: time

router.get "/:title"
, (req, res, next) ->
  if config.redis.switch
    cache.route()(req, res, next)
  else
    next()
, (req, res) ->
  Section.getStory req.params.title, (err, storysArr)->
    sectionsArr_new = []
    for story in storysArr
      sectionsArr_new.push
        url: "/story/" + story.id
        image: story.image
        title: story.title
        display_date: story.date
    time = Date.now() - res.socket._idleStart
    res.render "day",
      title: story.section_name + " - 知乎日报"
      section_title: story.section_name
      storys: sectionsArr_new
      time: time

module.exports = router
