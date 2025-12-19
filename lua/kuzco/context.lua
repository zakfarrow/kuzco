local Context = {}
Context.__index = Context

local TaskDesc = {
  FUNCTION_GEN =
  "Generate only the body of the function implementation. Do not include the function signature in the response."
}

function Context:new(o)
  o = o or {}
  setmetatable(o, self)

  local cursor = vim.api.nvim_win_get_cursor(0)
  o.cursor = {
    row = cursor[1], col = cursor[2]
  }

  o.prompt = {
    file_name = vim.fn.expand('%:t'),
    language = vim.bo.filetype,
    file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"),
    task_type = TaskDesc.FUNCTION_GEN,
  }
  return o
end

function Context:to_prompt()
  local formatted_prompt = string.format([[
    File: %s
    Language: %s
    ```%s
    %s
    ```

    Task: %s
    ]],
    self.prompt.file_name,
    self.prompt.language,
    self.prompt.language,
    self.prompt.file_content,
    self.prompt.task_type
  )

  return formatted_prompt
end

function Context:get_cursor()
  return self.cursor
end

return Context
