# Description:
#   Interact with AWEX API server
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_AWEX_API_URL
#
# Commands:
#   hubot awex ping - test API is responding
#   hubot awex sleep <website|app_name> - Sleep website
#   hubot awex wake <website|app_name> - Wake website
#   hubot awex owner <website> - Get owner email by website url
#   hubot awex abuse <email|website|app_name> - Set user as abuse (by email, website url, app name)
#   hubot awex unabuse <email|website|app_name> - Set user as not abuse (by email, website url, app name)
#   hubot awex impersonate <email|website|app_name> - Impersonate user (by email, website url, app name)
#
# Author:
#   fordnox

request = require('request')

hostinger_request = (method, url, params, handler) ->
  api_url = process.env.HUBOT_AWEX_API_URL

  request {
    baseUrl: api_url,
    url: url,
    method: method,
    form: params
  },
    (err, res, body) ->
      if err
        console.log "awex says: #{err}"
        return
      console.log "awex: #{url} -> #{body}"

      content = JSON.parse(body)
      if content.error?.message
        console.log "awex error: #{content.error.message}"
        handler "Error: #{body}"
      else
        handler content.result

module.exports = (robot) ->
  robot.respond /awex ping/i, (msg) ->
    hostinger_request 'GET', 'ping', null,
      (result) ->
        msg.send result

  robot.respond /awex sleep ([\S]+)/i, (msg) ->
    query = msg.match[1]
    hostinger_request 'POST', 'apps/sleep',
      {query : query},
      (result) ->
        msg.send result

  robot.respond /awex wake ([\S]+)/i, (msg) ->
    query = msg.match[1]
    hostinger_request 'POST', 'apps/wake',
      {query : query},
      (result) ->
        msg.send result

  robot.respond /awex owner ([\S]+)/i, (msg) ->
    hostname = msg.match[1]
    hostinger_request 'POST', 'owner',
      {hostname : hostname},
      (result) ->
        msg.send result

  robot.respond /awex abuse ([\S]+)/i, (msg) ->
    query = msg.match[1]
    hostinger_request 'POST', 'users/abuse',
      {query : query},
      (result) ->
        msg.send result

  robot.respond /awex unabuse ([\S]+)/i, (msg) ->
    query = msg.match[1]
    hostinger_request 'POST', 'users/remove-abuse',
      {query : query},
      (result) ->
        msg.send result

  robot.respond /awex impersonate ([\S]+)/i, (msg) ->
    query = msg.match[1]
    hostinger_request 'POST', 'users/impersonate',
      {query : query},
      (result) ->
        msg.send result