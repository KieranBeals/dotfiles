{ inputs, ... }:
{
  flake.overlays = {
    codex =
      final: _prev:
      let
        system = final.stdenv.hostPlatform.system;
        version = "0.125.0";
        targets = {
          x86_64-linux = {
            triple = "x86_64-unknown-linux-musl";
            hash = "sha256-SiClOUOn5qDF+kRj1OR8WN2OVT7OveRVpBB+mQa/sAE=";
          };
          aarch64-linux = {
            triple = "aarch64-unknown-linux-musl";
            hash = "sha256-cAvDskCWPWrg9PYHjU7eDrB5mf/AjRNIuLCR3qxLecg=";
          };
        };
        target =
          targets.${system}
            or (throw "codex binary release is not packaged for ${system}");
        archiveName = "codex-${target.triple}.tar.gz";
      in
      {
        codex = final.stdenv.mkDerivation {
          pname = "codex";
          inherit version;

          src = final.fetchurl {
            url = "https://github.com/openai/codex/releases/download/rust-v${version}/${archiveName}";
            hash = target.hash;
          };

          sourceRoot = ".";

          installPhase = ''
            runHook preInstall

            install -Dm755 codex-${target.triple} $out/bin/codex

            runHook postInstall
          '';

          meta = {
            description = "OpenAI Codex CLI";
            homepage = "https://github.com/openai/codex";
            license = final.lib.licenses.asl20;
            mainProgram = "codex";
            platforms = builtins.attrNames targets;
          };
        };
      };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    };
  };
}
