local curl = require("plenary.curl")
local OllamaClient = {}
OllamaClient.__index = OllamaClient

function OllamaClient:new(o, opts)
  o = o or {}
  setmetatable(o, self)
  o.base_url = opts and opts.base_url
  return o
end

function OllamaClient:generate(body, callback)
  curl.post(self.base_url .. "/api/generate", {
    headers = { ["Content-Type"] = "application/json" },
    body = body,
    callback = vim.schedule_wrap(function(response)
      if response.status == 200 then
        local response_body_json = vim.json.decode(response.body)
        callback(true, response_body_json.response)
      else
        callback(false, response.status)
      end
    end)
  })
end

return OllamaClient
