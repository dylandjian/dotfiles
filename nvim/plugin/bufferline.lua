require("bufferline").setup({
	options = {
		diagnostics = "coc",
		diagnostics_update_in_insert = true,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		offsets = {
			{
				filetype = "coc-explorer",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})
