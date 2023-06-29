{ pkgs, ... }:

{
  packages = [ pkgs.helix pkgs.git pkgs.nodejs_20 pkgs.nodejs_20.pkgs.pnpm ];
}
