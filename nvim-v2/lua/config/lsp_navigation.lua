local M = {}

function M.definition_or_references()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local changedtick = vim.api.nvim_buf_get_changedtick(buf)
  local positions = {}

  vim.lsp.buf_request_all(buf, "textDocument/definition", function(client)
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    positions[client.id] = params
    return params
  end, function(results)
    -- Ignore responses after the user has moved or edited the buffer.
    if vim.api.nvim_get_current_win() ~= win
      or vim.api.nvim_get_current_buf() ~= buf
      or vim.api.nvim_buf_get_changedtick(buf) ~= changedtick
      or not vim.deep_equal(vim.api.nvim_win_get_cursor(win), cursor)
    then
      return
    end

    for id, response in pairs(results) do
      local locations = response.result
      local params = positions[id]
      if not response.err and not response.error and locations and params then
        if locations.uri or locations.targetUri then
          locations = { locations }
        end
        for _, location in ipairs(locations) do
          local uri = location.targetUri or location.uri
          local range = location.targetSelectionRange or location.range
          local pos = params.position
          if uri == params.textDocument.uri and range then
            local after_start = pos.line > range.start.line
              or (pos.line == range.start.line and pos.character >= range.start.character)
            local before_end = pos.line < range["end"].line
              or (pos.line == range["end"].line and pos.character < range["end"].character)
            local at_start = pos.line == range.start.line and pos.character == range.start.character
            if after_start and (before_end or at_start) then
              Snacks.picker.lsp_references()
              return
            end
          end
        end
      end
    end

    Snacks.picker.lsp_definitions()
  end)
end

return M
