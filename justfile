# List targets
default:
    just --list

# Apply packages based on current lockfile
apply:
    NVIM= nvim --headless "+lua vim.pack.update(nil,{force=true,target='lockfile'})" +qa

# Link to default nvim config location
init:
    ln -sfn $$PWD $$HOME/.config/nvim

# Test renovate
test-renovate:
    LOG_LEVEL=debug , renovate --token $(gh auth token) --dry-run=full mikaelelkiaer/nvim-config
    # LOG_LEVEL=debug , renovate --token "$(gh auth token)" --platform local
