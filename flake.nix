{
  description = "A very basic flake to show how nix and flakes can be used to package and distribute scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        libraries = with pkgs; [
          python3Packages.questionary
        ];
      in
      {
        packages.default = pkgs.writers.writePython3Bin "git-cc-script" {
          inherit libraries;
        } (builtins.readFile ./script.py);

        devShells.default = pkgs.mkShell {
          packages =
            with pkgs;
            [
              python3
            ]
            ++ libraries;
        };

        apps.default = {
          type = "app";
          program = lib.getExe self.packages.${system}.default;
        };
      }
    );
}
