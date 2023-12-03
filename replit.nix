{ pkgs }: {
    deps = [
      pkgs.gforth
      pkgs.python311
      pkgs.luajit
      pkgs.luajitPackages.luarocks-nix
      pkgs.luajitPackages.penlight
      pkgs.luajitPackages.lpeg
      pkgs.elixir_1_14
      pkgs.jq
      pkgs.janet
      pkgs.cowsay
    ];
}
