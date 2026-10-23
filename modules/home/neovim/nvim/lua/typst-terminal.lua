-- Render Tinymist's in-memory PNG exports in a Neovim split through Snacks.
local M = {}
local preview

local function title(state, status)
  if vim.api.nvim_win_is_valid(state.win) then
    local text = (' Typst preview | Page %d / %d%s'):format(state.page, state.pages, status and (' | ' .. status) or '')
    if vim.wo[state.win].winbar ~= text then
      vim.wo[state.win].winbar = text
    end
  end
end

local function remove_file(file, convert)
  vim.fn.delete(file)
  -- Snacks caches image dimensions separately from the PNG.
  if convert then
    vim.fn.delete(convert:tmpfile 'png.info')
  end
end

local function remove_image(placement)
  if placement then
    placement:close()
    remove_file(placement.img.src, placement.img._convert)
  end
end

local function retire_images(state)
  for _, img in ipairs(state.retired) do
    img:del(state.placement.id)
    remove_file(img.src, img._convert)
  end
  state.retired = {}
end

function M.stop()
  local state = preview
  preview = nil
  if not state then
    return
  end
  vim.api.nvim_del_augroup_by_id(state.group)
  if state.request then
    state.client:cancel_request(state.request)
  end
  if state.preparing then
    state.preparing:abort()
  end
  retire_images(state)
  remove_image(state.placement)
  if vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  if vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  vim.fn.delete(state.dir, 'rf')
end

local render
render = function(state)
  if preview ~= state then
    return
  end
  if not vim.api.nvim_buf_is_valid(state.source) or not vim.api.nvim_win_is_valid(state.win) then
    M.stop()
    return
  end
  if state.busy then
    return
  end
  state.busy = true
  local revision = state.revision
  title(state, 'Compiling')
  local sent, request = state.client:request('workspace/executeCommand', {
    command = 'tinymist.exportPng',
    arguments = {
      vim.api.nvim_buf_get_name(state.source),
      { pages = { tostring(state.page) }, ppi = 144 },
      { write = false, open = false },
    },
  }, function(err, result)
    vim.schedule(function()
      if preview ~= state then
        return
      end
      state.busy = false
      state.request = nil
      if revision ~= state.revision then
        render(state)
        return
      end
      if not vim.api.nvim_win_is_valid(state.win) or not vim.api.nvim_buf_is_valid(state.buf) then
        M.stop()
        return
      end
      result = type(result) == 'table' and result or nil
      state.pages = result and result.total_pages or state.pages
      if state.page > state.pages and state.pages > 0 then
        state.page = state.pages
        M.refresh()
        return
      end
      local item = result and (result.items and result.items[1] or result)
      if err or not item or not item.data then
        title(state, 'Compile error; see source diagnostics')
        return
      end
      local signature = vim.fn.sha256(item.data)
      if signature == state.signature then
        state.image_revision = revision
        title(state, state.drawn_signature == signature and 'Ready' or 'Rendering')
        return
      end
      state.image = state.image + 1
      local file = state.dir .. '/' .. state.image .. '.png'
      local handle, write_err = io.open(file, 'wb')
      if not handle then
        title(state, 'Could not write preview')
        vim.notify(write_err, vim.log.levels.ERROR)
        return
      end
      handle:write(vim.base64.decode(item.data))
      handle:close()
      state.busy = true
      title(state, 'Rendering')
      -- Prepare dimensions before attaching the image, so Snacks never clears the
      -- preview buffer to show its loading spinner between successful renders.
      state.preparing = Snacks.image.convert.convert {
        src = file,
        on_done = function(convert)
          if preview ~= state then
            remove_file(file, convert)
            return
          end
          state.preparing = nil
          state.busy = false
          if revision ~= state.revision then
            remove_file(file, convert)
            render(state)
            return
          end
          if not vim.api.nvim_win_is_valid(state.win) or not vim.api.nvim_buf_is_valid(state.buf) then
            remove_file(file, convert)
            M.stop()
            return
          end
          if convert:error() then
            remove_file(file, convert)
            title(state, 'Image conversion failed')
            return
          end
          if state.placement then
            -- Keep the buffer/extmarks and old terminal image until the new image
            -- has been transferred and its placement has actually been drawn.
            local placement = state.placement
            local img = Snacks.image.image.new(file)
            table.insert(state.retired, placement.img)
            placement.img = img
            placement._state = nil
            img:place(placement)
            placement:update()
          else
            state.placement = Snacks.image.placement.new(state.buf, file, {
              auto_resize = true,
              conceal = true,
              on_update_pre = function(placement)
                if vim.api.nvim_win_is_valid(state.win) then
                  placement.opts.max_width = math.max(1, vim.api.nvim_win_get_width(state.win) - 2)
                  placement.opts.max_height = math.max(1, vim.api.nvim_win_get_height(state.win) - 1)
                end
                -- A reused placement must reappear when returning to its tab.
                if placement.hidden and #placement:state().wins > 0 then
                  placement.hidden = false
                end
              end,
              on_update = function()
                if preview ~= state then
                  return
                end
                if #state.retired > 0 then
                  -- Flush the updated placeholder grid before deleting its old image.
                  vim.cmd.redraw()
                  retire_images(state)
                end
                state.drawn_signature = state.signature
                if state.image_revision == state.revision and not state.busy then
                  title(state, 'Ready')
                end
              end,
            })
          end
          state.signature = signature
          state.image_revision = revision
        end,
      }
      state.preparing:run()
    end)
  end, state.source)
  state.request = request
  if not sent then
    state.busy = false
    title(state, 'Tinymist disconnected')
  end
end

function M.refresh()
  local state = preview
  if not state then
    return
  end
  state.revision = state.revision + 1
  local revision = state.revision
  title(state, 'Pending')
  -- Debounce keystrokes, and discard exports superseded by a newer edit.
  vim.defer_fn(function()
    if preview == state and state.revision == revision then
      render(state)
    end
  end, 250)
end

function M.page(delta)
  if preview then
    preview.page = math.max(1, math.min(preview.pages, preview.page + delta))
    M.refresh()
  end
end

function M.open()
  if preview then
    return
  end
  local source = vim.api.nvim_get_current_buf()
  if vim.bo[source].filetype ~= 'typst' or vim.api.nvim_buf_get_name(source) == '' then
    vim.notify('Open a named .typ file to preview it.', vim.log.levels.WARN)
    return
  end
  local client = vim.lsp.get_clients({ bufnr = source, name = 'tinymist' })[1]
  if not client or not client.initialized then
    vim.notify('Tinymist must be running first. Check :Mason and :LspInfo.', vim.log.levels.WARN)
    return
  end
  if vim.fn.executable 'magick' ~= 1 then
    vim.notify('ImageMagick is required for the terminal preview. Apply the Nix package profile first.', vim.log.levels.WARN)
    return
  end

  Snacks.image.terminal.detect(function()
    if preview or not vim.api.nvim_buf_is_valid(source) then
      return
    end
    -- Zellij gained native Kitty graphics in 0.45; Snacks still marks it unsupported.
    -- Use ordinary placements and transmit image data through the multiplexer.
    local host = (vim.env.TERM_PROGRAM or ''):lower()
    local graphics_host = host:find('ghostty', 1, true) or host:find('wezterm', 1, true) or vim.env.KITTY_WINDOW_ID
    if vim.env.ZELLIJ and graphics_host then
      local result = vim.system({ 'zellij', '--version' }, { text = true }):wait(1000)
      local major, minor = (result.stdout or ''):match '(%d+)%.(%d+)'
      if major and (tonumber(major) > 0 or tonumber(minor) >= 45) then
        local env = Snacks.image.terminal.env()
        env.supported = true
        env.placeholders = false
        env.remote = true
      end
    end
    if not Snacks.image.supports_terminal() then
      vim.notify('Terminal preview needs Ghostty/Kitty graphics support (Zellij 0.45+). Use <Space>tb for the browser.', vim.log.levels.WARN)
      return
    end
    local source_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, 'typst://preview/' .. source)
    vim.bo[buf].filetype = 'image'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].modifiable = false
    vim.cmd 'botright vsplit'
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_width(win, math.max(20, math.floor(vim.o.columns * 0.45)))
    vim.wo[win].winfixwidth = true
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, 'p')
    local state = {
      source = source,
      client = client,
      buf = buf,
      win = win,
      dir = dir,
      page = 1,
      pages = 1,
      image = 0,
      revision = 0,
      retired = {},
      group = vim.api.nvim_create_augroup('typst-terminal-preview', { clear = true }),
    }
    preview = state
    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP', 'BufWritePost' }, {
      group = state.group,
      pattern = '*.typ',
      callback = M.refresh,
    })
    vim.api.nvim_create_autocmd('WinClosed', {
      group = state.group,
      pattern = tostring(win),
      callback = function()
        vim.schedule(function()
          if preview == state then
            M.stop()
          end
        end)
      end,
    })
    vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
      group = state.group,
      buffer = source,
      callback = function()
        vim.schedule(function()
          if preview == state then
            M.stop()
          end
        end)
      end,
    })
    vim.api.nvim_create_autocmd('ExitPre', { group = state.group, callback = M.stop })
    vim.keymap.set('n', 'q', M.stop, { buffer = buf, desc = 'Close Typst preview' })
    vim.keymap.set('n', ']p', function()
      M.page(1)
    end, { buffer = buf, desc = 'Next page' })
    vim.keymap.set('n', '[p', function()
      M.page(-1)
    end, { buffer = buf, desc = 'Previous page' })
    vim.api.nvim_set_current_win(source_win)
    M.refresh()
  end)
end

function M.toggle()
  if preview then
    M.stop()
  else
    M.open()
  end
end

function M.setup()
  vim.api.nvim_create_user_command('TypstTerminalPreview', M.open, {})
  vim.api.nvim_create_user_command('TypstTerminalPreviewToggle', M.toggle, {})
  vim.api.nvim_create_user_command('TypstTerminalPreviewStop', M.stop, {})
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('typst-terminal-keymaps', { clear = true }),
    pattern = 'typst',
    callback = function(event)
      vim.keymap.set('n', '<leader>tp', M.toggle, { buffer = event.buf, desc = '[T]ypst terminal [P]review' })
      vim.keymap.set('n', '<leader>tn', function()
        M.page(1)
      end, { buffer = event.buf, desc = '[T]ypst [N]ext page' })
      vim.keymap.set('n', '<leader>tN', function()
        M.page(-1)
      end, { buffer = event.buf, desc = '[T]ypst previous page' })
    end,
  })
end

return M
