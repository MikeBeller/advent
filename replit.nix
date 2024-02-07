{ pkgs }: {
    deps = [
      pkgs.unzip
      pkgs.wget
      pkgs.rlwrap
      pkgs.lsof
      pkgs.gforth
      pkgs.python311
      pkgs.lua54Packages.lua
      pkgs.lua54Packages.penlight
      pkgs.lua54Packages.lpeg      pkgs.elixir_1_14
      pkgs.jq
      pkgs.janet
      pkgs.SDL2
      pkgs.SDL2_image
      pkgs.xxd
      pkgs.cowsay
      pkgs.go
    ];
}
