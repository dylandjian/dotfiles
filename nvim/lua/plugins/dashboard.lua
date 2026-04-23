local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local function getGreeting(name)
  local tableTime = os.date("*t")
  local datetime = os.date(" %Y-%m-%d-%A   %H:%M:%S ")
  local hour = tableTime.hour
  local greetingsTable = {
    [1] = "  Sleep well",
    [2] = "  Good morning",
    [3] = "  Good afternoon",
    [4] = "  Good evening",
    [5] = "󰖔  Good night",
  }
  local greetingIndex = 0
  if hour == 23 or hour < 7 then
    greetingIndex = 1
  elseif hour < 12 then
    greetingIndex = 2
  elseif hour >= 12 and hour < 18 then
    greetingIndex = 3
  elseif hour >= 18 and hour < 21 then
    greetingIndex = 4
  elseif hour >= 21 then
    greetingIndex = 5
  end
  return datetime .. "  " .. greetingsTable[greetingIndex] .. ", " .. name
end

local logo = [[



     ████ ██████           █████      ██
    ███████████             █████
    █████████ ███████████████████ ███   ███████████
   █████████  ███    █████████████ █████ ██████████████
  █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████

    ]]

local greeting = getGreeting("Dylan")
local logoWidth = logo:find("\n") - 1
local padding = math.floor((logoWidth - #greeting) / 2)
local adjustedLogo = logo .. "\n" .. string.rep(" ", padding) .. greeting

dashboard.section.header.val = vim.split(adjustedLogo, "\n")

dashboard.section.buttons.val = {
  dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find file", ":cd $HOME | silent Telescope find_files hidden=true no_ignore=true <CR>"),
  dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("u", "󱐥  Update plugins", "<cmd>lua vim.pack.update()<CR>"),
  dashboard.button("c", "  Settings", ":e $HOME/.config/nvim/init.lua<CR>"),
  dashboard.button("p", "  Projects", ":e $HOME/Work <CR>"),
  dashboard.button("d", "󱗼  Dotfiles", ":e $HOME/Work/dotfiles <CR>"),
  dashboard.button("q", "󰿅  Quit", "<cmd>qa<CR>"),
}

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local plugins = vim.pack.get()
    local count = #plugins
    local ms = math.floor((vim.uv.hrtime() - vim.g._start_time) / 1e6 * 100 + 0.5) / 100
    dashboard.section.footer.val = {
      " ", " ", " ",
      " Loaded " .. count .. " plugins  in " .. ms .. " ms ",
    }
    dashboard.section.header.opts.hl = "DashboardFooter"
    pcall(vim.cmd.AlphaRedraw)
  end,
})

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
