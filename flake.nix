{
  description = "Unofficial Binary Ninja package";

  outputs = { self, nixpkgs }:
    let makeBinjaWrapper = { binaryNinjaPath, extraPythonPackages ? (p: []), extraPackages ? [] }: (
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        bn-python = pkgs.python39.withPackages (p: with p; [
          pip
        ] ++ (extraPythonPackages p));
      in
      (pkgs.buildFHSUserEnv {
        name = "binaryninja";
        runScript = "${binaryNinjaPath}/binaryninja";
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
          ] ++ extraPackages);
      })
    ); in
    {
      makeBinjaWrapper = makeBinjaWrapper;
    };
}
