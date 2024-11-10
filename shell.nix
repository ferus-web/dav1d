with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    pkg-config
    dav1d.dev
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    dav1d
  ];
}
