help:		## Show this help
	@echo "# Help"
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

check-updates:	## Count number of plugin updates
	@nvim --headless +'Lazy! check | lua =require("lazy.status").updates()' +qa 2>&1 >/dev/null

update:		## Update plugins
	NVIM= nvim --headless "+Lazy! update" +qa
	@git add lazy-lock.json
	@git diff --cached --exit-code &>/dev/null && \
		echo "[INF] No updates" >&2 || \
		git commit -m "chore: Update plugins"

init:		## Init
	ln -sfn $$PWD $$HOME/.config/nvim

