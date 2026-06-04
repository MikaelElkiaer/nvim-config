# List targets
default:
    just --list

# Apply packages based on current lockfile
apply:
    @just list-outdated | jq -R . | paste -sd, - | { read -r x; NVIM= nvim --headless "+lua vim.pack.update({$x},{force=true,target='lockfile'})" +qa; }

# Delete packages that are no longer active
delete:
    @just list-deleted | while read -r p; do NVIM= nvim --headless "+lua=vim.pack.del({\"$p\"})" +qa; echo; done

# Link to default nvim config location
init:
    ln -sfn $$PWD $$HOME/.config/nvim

# List packages that have been updated but not yet applied
list-outdated:
    @{ echo 'return '; NVIM= nvim --headless "+lua=vim.pack.get()" +qa 2>&1;} | yq -p lua 'map(select(.active) | "\(.spec.name)\t\(.path)\t\(.rev)")[]' | while read -r n p r; do or=$(git -C "$p" rev-parse HEAD); [ $r = $or ] || echo $n; done

# List packages that are no longer active and should be deleted
list-deleted:
    @{ echo 'return '; NVIM= nvim --headless "+lua=vim.pack.get()" +qa 2>&1;} | yq -p lua 'map(select(.active != true) | .spec.name)[]'

# Test renovate
test-renovate:
    LOG_LEVEL=debug , renovate --token $(gh auth token) --dry-run=full mikaelelkiaer/nvim-config
    # LOG_LEVEL=debug , renovate --token "$(gh auth token)" --platform local
