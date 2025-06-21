return {
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      size = { h = 75, w = 90 },
      terminals = {
        { name = "Terminal" },
      },
    },
    cmd = "FloatermToggle",
    keys = {
      {
        '<c-/>',
        function()
          require('floaterm').toggle()
        end,
        desc = 'Toggle terminal',
        mode = { 'n' },
      },
    }
  }
}
