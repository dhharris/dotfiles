# nvim configuration

TODO: Add more functionality from
https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
TODO: Format lua files

## Quickstart
Open nvim

Navigate to Lazy plugin manager
```vim
:Lazy
```

Install via UI

## Headless tests
Run headless tests from the `nvim` folder with the real `init.lua`:

```sh
cd /Users/dhh/dotfiles/nvim
XDG_STATE_HOME=/tmp XDG_CACHE_HOME=/tmp nvim --headless -u init.lua -l tests/<name>.lua
```

Example:

```sh
cd /Users/dhh/dotfiles/nvim
XDG_STATE_HOME=/tmp XDG_CACHE_HOME=/tmp nvim --headless -u init.lua -l tests/headless_python_completion.lua
```

Notes:
- Do not set `XDG_DATA_HOME` for these tests.
- Leaving `XDG_DATA_HOME` alone keeps the normal `lazy.nvim` install and Mason tools available.
- `XDG_STATE_HOME` and `XDG_CACHE_HOME` are redirected to avoid shada, logs, and cache noise.

Test conventions for scripts in `tests/`:
- Print `OK: ...` and exit 0 on success.
- Print `SKIP: ...` and exit 0 when prerequisites are missing.
- Raise an error and exit non-zero on failure.
