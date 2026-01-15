{
  gerrit,
  fetchurl,
}:

gerrit.overrideAttrs (final: prev: {
  version = "3.12.3";
  src = fetchurl {
    url = "https://gerrit-releases.storage.googleapis.com/gerrit-${final.version}.war";
    hash = "sha256-egPuxGfRk8uB+7hzdrrEOT9wfBxlkaSjRpw2z9RYXAI=";
  };
})
