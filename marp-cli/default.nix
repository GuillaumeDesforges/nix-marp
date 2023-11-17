{ stdenv
, system
, autoPatchelfHook
}:

let
  data = builtins.fromJSON (builtins.readFile ./data/${system}.json);
in

stdenv.mkDerivation rec {
  name = "marp-cli";
  version = "3.4.0";

  src = builtins.fetchurl {
    url = data.url;
    sha256 = data.hash;
  };

  # patchelf downloaded binaries
  nativeBuildInputs = [ autoPatchelfHook ];
  dontStrip = true;
  dontStripHost = true;
  dontStripTarget = true;
  dontPruneLibtoolFiles = true;

  buildInputs = [ stdenv.cc.cc.lib ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackPhase = ''
    runHook preUnpack
    
    tar -xzf $src
    
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp marp $out/bin/

    runHook postInstall
  '';
}
