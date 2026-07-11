# Android Studio — how it's managed

**Short version:** Android Studio is **not** installed from nixpkgs. It's a
manually-downloaded official tarball, extracted to `~/android-studio`, and run
through an FHS sandbox via a small wrapper. To update it, you replace the folder
— no `home-manager switch` needed.

## Why not the nixpkgs package?

The nixpkgs `android-studio` (stable channel) lags well behind Google's
releases. On NixOS 26.05 it was pinned to `2025.3.4.7` while the current stable
was `2026.1.1.x`. Rather than chase it, we run the exact build Google ships.

A raw Linux binary can't execute directly on NixOS (there's no
`/lib64/ld-linux-x86-64.so.2` and no system libraries at standard paths), so the
download is launched inside [`steam-run`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/steam/fhsenv.nix),
a ready-made FHS environment that provides all the libs Studio expects
(OpenGL, X11/Wayland, fontconfig, …). `steam-run` also passes `/dev/kvm`
through, so the emulator gets KVM hardware acceleration.

## What's wired into `home.nix`

In the `let` block:

```nix
studio = pkgs.writeShellScriptBin "studio" ''
  exec ${pkgs.steam-run}/bin/steam-run "$HOME/android-studio/bin/studio" "$@"
'';
```

In `home.packages`:

```nix
studio       # the wrapper above -> gives you the `studio` command
steam-run    # also exposed directly, handy for other downloaded binaries
```

The nixpkgs package is intentionally left out. If you ever want to go back to
the nix-managed version, add one of these to `home.packages` instead of
`studio` (and drop the wrapper):

```nix
# android-studio                    # nixpkgs stable (lags; was 2025.3.4.7 on 26.05)
# androidStudioPackages.beta        # e.g. 2026.1.1.x, already in the 26.05 channel
# androidStudioPackages.canary      # bleeding edge, from the channel
```

## How to update Studio later

1. Download the latest Linux `.tar.gz` from
   <https://developer.android.com/studio> (or the release archive).
2. Extract it and swap the folder in — same filesystem, so it's instant:

   ```bash
   cd ~/Downloads
   tar xzf android-studio-*-linux.tar.gz
   rm -rf ~/android-studio
   mv android-studio ~/android-studio        # the inner `android-studio/` dir
   ```

3. Run `studio` — done. No `home-manager switch`, no config change, because the
   wrapper always points at `~/android-studio/bin/studio`.

Notes:
- Studio's built-in "Update" won't work (the install dir is a plain folder we
  manage by hand, and updates would fight the tarball layout). Always update by
  replacing the folder as above.
- Keep the folder name exactly `~/android-studio` or the wrapper won't find it.
- If a launch ever fails after a system upgrade, rebuild the `steam-run`
  reference with `home-manager switch` (the FHS libs are pinned to your channel).

## Verifying the emulator acceleration

KVM is enabled at the system level (`programs`/groups in
`/etc/nixos/configuration.nix` — user is in the `kvm` group, modules auto-load).
To confirm from the SDK:

```bash
<sdk>/emulator/emulator -accel-check
# -> accel: 0  /  KVM (version N) is installed and usable.
```

## Related environment notes

- System: **NixOS 26.05** (channel-based, not a flake).
- home-manager: standalone on the **release-26.05** channel. The old
  `flake.nix`/`flake.lock` here are disabled (`.disabled`) because the newer
  home-manager CLI auto-detects a `flake.nix` and would use its stale pins.
- Downloaded binaries in general: run them with `steam-run <binary>` (or add a
  `writeShellScriptBin` wrapper like `studio`).
