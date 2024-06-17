init:
	ln -sfn $$PWD $$HOME/.config/nvim

update-lazy-lock:
	cp ./lazy-lock.json ./lazy-lock.json.bak
	git stash -u
	git switch lazy-lock
	cp lazy-lock.json.bak lazy-lock.json
	git add lazy-lock.json
	git commit -m "Update lazy-lock.json"
	git push
	git switch -
	mv lazy-lock.json.bak lazy-lock.json
	git stash pop || true
