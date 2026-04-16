help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

update:		## Update plugins
	NVIM= nvim --headless "+lua vim.pack.update(nil,{force=true})" +qa
	@git add nvim-pack-lock.json
	@git diff --cached --exit-code &>/dev/null && \
		echo "[INF] No updates" >&2 || \
		git commit -m "chore: Update plugins"

init:		## Init
	ln -sfn $$PWD $$HOME/.config/nvim

