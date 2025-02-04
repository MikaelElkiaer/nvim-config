help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

update:		## Update plugins
	NVIM= nvim --headless "+Lazy! update" +qa
	@git add lazy-lock.json
	@git diff --cached --exit-code &>/dev/null && \
		echo "[INF] No updates" >&2 || \
		git commit -m "chore: Update plugins"

init:		## Init
	ln -sfn $$PWD $$HOME/.config/nvim

