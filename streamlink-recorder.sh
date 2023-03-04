#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

oauth_token = ''

function get_oauth_token() {
	oauth_token = $(curl -s -X POST -H "Client-ID: $clientId" -d "client_id=$clientId&client_secret=$clientSecret&grant_type=client_credentials" https://id.twitch.tv/oauth2/token | jq -r '.access_token')
}

function validate_oauth_token() {
	if $(curl -X GET -H "Authorization: OAuth $1" https://id.twitch.tv/oauth2/validate | jq -r '.status') -eq 401; then
		get_oauth_token
	fi
}

while [ true ]; do
	Date=$(date +%Y%m%d-%H%M%S)
	validate_oauth_token $oauth_token
	$streamOptions += " --twitch-api-header=\"Authorization=OAuth $oauth_token\""
	streamlink $streamOptions $streamLink $streamQuality -o /home/download/$streamName"-$Date".mkv
	sleep 60s
done