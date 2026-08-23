-- nvim half of the seamless tmux <-> nvim pane navigation.
-- The tmux half is christoomey/vim-tmux-navigator (see ~/.config/tmux/tmux.conf).
-- keymaps.lua already binds <C-h/j/k/l> and calls :NvimTmuxNavigate* when this
-- plugin is loaded, falling back to `wincmd` otherwise — so no keys are defined
-- here, only the commands those keymaps look for.
return {
	{
		"alexghergh/nvim-tmux-navigation",
		event = "VeryLazy",
		opts = {
			disable_when_zoomed = true,
		},
	},
}
