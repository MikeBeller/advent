{ pkgs }: {
    deps = [
      pkgs.python311Packages.scipy
      pkgs.xsimd
      pkgs.pkg-config
      pkgs.libxcrypt
      pkgs.neovim
      pkgs.unzip
      pkgs.wget
      pkgs.rlwrap
      pkgs.lsof
      pkgs.gforth
      pkgs.python311
      pkgs.python311Packages.numpy
      pkgs.luaPackages.lua
      pkgs.luaPackages.penlight
      pkgs.luaPackages.lpeg
      pkgs.elixir_1_14
      pkgs.jq
      pkgs.janet
      pkgs.SDL2
      pkgs.SDL2_image
      pkgs.xxd
      pkgs.cowsay
      pkgs.go
    ];
}
