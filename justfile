# List targets
default:
    just --list

# Apply packages based on current lockfile
apply:
    NVIM= nvim --headless "+lua vim.pack.update(nil,{force=true,target='lockfile'})" +qa

delete:
    @just list-deleted | while read -r p; do NVIM= nvim --headless "+lua=vim.pack.del({\"$p\"})" +qa; echo; done

list-out-of-date:
    @{ echo 'return '; NVIM= nvim --headless "+lua=vim.pack.get()" +qa 2>&1;} | yq -p lua 'map(select(.active) | "\(.spec.name)\t\(.rev)")[]' | while read -r p r; do nr=$(p=$p yq -p json -o yaml '.plugins[strenv(p)].rev' nvim-pack-lock.json); [ $r = $nr ] || echo $p; done

list-deleted:
  @{ echo 'return '; NVIM= nvim --headless "+lua=vim.pack.get()" +qa 2>&1;} | yq -p lua 'map(select(.active != true) | .spec.name)[]'

# Link to default nvim config location
init:
    ln -sfn $$PWD $$HOME/.config/nvim

# Test renovate
test-renovate:
    LOG_LEVEL=debug , renovate --token $(gh auth token) --dry-run=full mikaelelkiaer/nvim-config
    # LOG_LEVEL=debug , renovate --token "$(gh auth token)" --platform local
