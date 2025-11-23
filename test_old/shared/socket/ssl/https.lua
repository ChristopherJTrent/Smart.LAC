SET_RESPONSES = T{}

local https = {}

function https.request(url)
	if SET_RESPONSES:haskey(url) then
		return SET_RESPONSES[url].body, SET_RESPONSES[url].statusCode, 1, 1
	end
end