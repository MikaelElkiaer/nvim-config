help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

update:		## Update plugins
	@echo "Update not implemented for vim.pack yet"

init:		## Init
	ln -sfn $$PWD $$HOME/.config/nvim

