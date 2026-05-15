help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

update:		## Update plugins
	NVIM= nvim --headless "+lua vim.pack.update(nil,{force=true,target='lockfile'})" +qa

test-renovate:	## Test renovate
	LOG_LEVEL=debug , renovate --token $(gh auth token) --dry-run=full mikaelelkiaer/nvim-config
	# LOG_LEVEL=debug , renovate --token "$(gh auth token)" --platform local

init:		## Init
	ln -sfn $$PWD $$HOME/.config/nvim

