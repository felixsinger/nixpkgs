{
  gerrit,
  fetchurl,
}:

gerrit.overrideAttrs (final: prev: {
  version = "3.11.7";
  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${final.version}.war";
    hash = "sha256-eDf7MW3ikW2yiPEPVZA5RxRbYeSw0ucbS1rsFcdzdk4=";
  };
})
