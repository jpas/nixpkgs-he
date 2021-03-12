{ pkgs ? import <nixpkgs> { } }:

with pkgs.lib;

let
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: isAttrs p && p.shouldRecurseForDerivations or false;

  flattenPkgs = s:
    let
      f = p:
        if shouldRecurseForDerivations p then flattenPkgs p
        else if isDerivation p then [ p ]
        else [ ];
    in
    concatMap f (attrValues s);

  outputsOf = p: map (o: p.${o}) p.outputs;

in

rec {
  allPkgs = flattenPkgs (import ./default.nix { inherit pkgs; });

  buildPkgs = filter isBuildable allPkgs;
  cachePkgs = filter isCacheable buildPkgs;

  buildOutpus = concatMap outputsOf buildPkgs;
  cacheOutpus = concatMap outputsOf cachePkgs;
}
