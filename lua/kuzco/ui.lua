local UI = {}
UI.__index = UI

function UI:new(o)
  o = o or {}
  setmetatable(o, self)
  return o
end

function UI:show_loading(timer)
  local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local frame = 1

  timer:start(0, 80, vim.schedule_wrap(function()
    vim.api.nvim_echo({ { spinner_frames[frame] .. " Generating...", "Normal" } }, false, {})
    frame = (frame % #spinner_frames) + 1
  end))
end

function UI:stop_loading(timer, success, result)
  timer:stop()
  timer:close()

  if not success then
    print("Error: " .. result)
  end
end

function UI:insert_text(to_insert, row)
  local lines = vim.split(to_insert, "\n")
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end

return UI
