{ pkgs }: {
    deps = [
      pkgs.python39Full
      pkgs.luajit
      pkgs.luajitPackages.luarocks-nix
      pkgs.luajitPackages.penlight
      pkgs.elixir_1_14
      pkgs.cowsay
    ];
}
