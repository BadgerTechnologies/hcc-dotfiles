require('which-key').setup({
  triggers_blacklist = {
    -- My mapping of jk and kj to <Esc> in command mode causes which-key to trigger
    -- on j and k in command mode, which breaks horribly. So disable this.
    c = { 'j', 'k' },
  },
})
