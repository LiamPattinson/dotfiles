local cmp = require('cmp')

local cmp_window_config = {
  winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
}

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(cmp_window_config),
    documentation = cmp.config.window.bordered(cmp_window_config),
  },
})
