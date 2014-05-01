# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.create_request').on 'click', (event) ->
		event.preventDefault()
		$.post url

	$.get(window.location.origin + '/requests.json', (data) ->
		$.each(data.requests, (index, request) ->
			request.position = index + 1
			newRequest = Mustache.render($('#request').html(),request)
			$(newRequest).appendTo('.scroll ul')
		)
	)

	dispatcher = new WebSocketRails(window.location.host + '/websocket');
		
	channel_created = dispatcher.subscribe 'request_created'
	channel_created.bind 'new', (request) ->
		if($('.scroll ul').length)
			$.get(window.location.origin + '/requests.json', (data) ->
				newData = data.requests[data.requests.length-1]
				newData.position = data.requests.length
				newRequest = Mustache.render($('#request').html(),newData)
				$(newRequest).appendTo('.scroll ul')
			)

	channel_deleted = dispatcher.subscribe 'request_deleted'
	channel_deleted.bind 'destroy', (request_id) ->
		if($('.scroll ul').length)
			$("##{request_id}").remove()
			$('.scroll ul li').each (index, request) ->
				$(request).find('.position').html(index+1)