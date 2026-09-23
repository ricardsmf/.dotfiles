return {
	{
		"nvim-pack/nvim-spectre",
		lazy = true,
		cmd = { "Spectre" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"Shatur/neovim-ayu",
		},
		config = function()
			local colors = require("ayu.colors")
			colors.generate(false)

			vim.api.nvim_set_hl(0, "SpectreSearch", { bg = colors.error, fg = colors.bg })
			vim.api.nvim_set_hl(0, "SpectreReplace", { bg = colors.string, fg = colors.bg })

			require("spectre").setup({
				highlight = {
					search = "SpectreSearch",
					replace = "SpectreReplace",
				},
				mapping = {
					["send_to_qf"] = {
						map = "<C-q>",
						cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
						desc = "send all items to quickfix",
					},
				},
				-- replace_engine = {
				-- 	sed = {
				-- 		cmd = "sed",
				-- 		args = {
				-- 			"-i",
				-- 			"",
				-- 			"-E",
				-- 		},
				-- 	},
				-- },
			})
		end,
	},
}
