return {
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			local colors = require("ayu.colors")
			colors.generate(false)

			require("ayu").setup({
				mirage = false,
				terminal = true,
				overrides = {
					-- Telescope highlights to match editor background
					TelescopeNormal = { bg = colors.bg },
					TelescopeBorder = { fg = colors.tag, bg = colors.bg },
					TelescopePromptNormal = { bg = colors.bg },
					TelescopePromptBorder = { fg = colors.tag, bg = colors.bg },
					TelescopeResultsNormal = { bg = colors.bg },
					TelescopeResultsBorder = { fg = colors.tag, bg = colors.bg },
					TelescopePreviewNormal = { bg = colors.bg },
					TelescopePreviewBorder = { fg = colors.tag, bg = colors.bg },
					TelescopeTitle = { fg = colors.accent, bg = colors.bg },
					TelescopePromptTitle = { fg = colors.accent, bg = colors.bg },
					TelescopeResultsTitle = { fg = colors.accent, bg = colors.bg },
					TelescopePreviewTitle = { fg = colors.accent, bg = colors.bg },
				},
			})
			vim.cmd.colorscheme("ayu-dark")

			-- Semantic highlights stay off; treesitter handles highlighting
			for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
				vim.api.nvim_set_hl(0, group, {})
			end
		end,
	},
}
