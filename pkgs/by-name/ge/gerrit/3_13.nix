{ }:

{ pkgs }:

(pkgs.callPackage ./generic.nix).overrideAttrs (prevAttrs: {
   version = "3.13.1";
   src.hash = "sha256-4+Z1q1cHEM5IaG+SAS7JgiCypfjM8W2Zaa25/KGaoqw=";
})
