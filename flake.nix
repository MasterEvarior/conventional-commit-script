{
  description = "A very basic flake to show how nix and flakes can be used to package and distribute scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        libraries = with pkgs; [
          python3Packages.questionary
        ];
        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            # Code and Flake
            black.enable = true;
            nixfmt.enable = true;

            # README.md
            mdformat.enable = true;

            # GitHub Workflows
            yamllint.enable = true;

            # Renovate
            prettier.enable = true;
          };
        };
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

          shellHook = ''
            git config --local core.hooksPath .githooks/
          '';
        };

        apps.default = {
          type = "app";
          program = lib.getExe self.packages.${system}.default;
          meta.description = "A simple python script that helps you generate conventional-commit messages";
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          lint = treefmtEval.config.build.check self;
        };
      }
    );
}
