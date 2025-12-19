local OllamaClient = require("kuzco.ollama_client")
local UI = require("kuzco.ui")
local Context = require("kuzco.context")

local M = {}

local defaults = {
  base_url = "http://localhost:11434"
}

function M.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})
  local client = OllamaClient:new(nil, config)
  local ui = UI:new(nil)

  vim.keymap.set('n', '<leader>kg', function()
    local timer = vim.loop.new_timer()
    ui:show_loading(timer)

    local ctx = Context:new(nil)
    local prompt = ctx:to_prompt()
    local req_body = vim.json.encode(
      {
        model = config.model,
        stream = false,
        prompt = prompt,
        system = "Programming project objective: build a 'to-do notes' CLI app in Lua.",
        format = {
          type = "object",
          properties = {
            function_body = {
              type = "string",
              description = "The implementation code for the function body"
            }
          },
          required = { "function_body" }
        },
      }
    )
    client:generate(
      req_body, function(success, result)
        ui:stop_loading(timer, success, result)
        ui:insert_text(vim.json.decode(result).function_body, ctx:get_cursor().row)
      end
    )
  end, { desc = "Generate code snippet" })
end

return M
