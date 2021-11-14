{
  description = "Unofficial Binary Ninja package";

  outputs = { self, nixpkgs }:
    let fhs = (
      let
        bn-python = nixpkgs.legacyPackages.x86_64-linux.python39.withPackages (p: with p; [
          colorama
          pwntools
          pip
        ]);
      in
      (nixpkgs.legacyPackages.x86_64-linux.buildFHSUserEnv {
        name = "binaryninja-fhs";
        runScript = "./binaryninja/binaryninja";
        targetPkgs = nixpkgs: (with nixpkgs;
          [
            stdenv.cc.cc

            zlib
            glib
            fontconfig
            dbus
            libglvnd
            libxkbcommon
            alsa-lib
            nss
            krb5
            freetype
            nspr
            expat

            libudev0-shim

            bn-python
          ]) ++ (with nixpkgs.xlibs;
          [
            libX11
            libXi
            libXfixes
            libXrender
            libXcomposite
            libXdamage
            libXcursor
            libXext
            libxcb
            libXtst
            libXrandr
            xcbutilwm
            xcbutilimage
            xcbutilkeysyms
            xcbutilrenderutil
          ]);
      })
    ); in
    {
      defaultPackage.x86_64-linux = fhs;
      defaultApp.x86_64-linux = fhs;
    };
}
