# LOCAL.md — Machine-Specific Agent Policy

> **This file overrides the `docs/` book and the raw command forms in
> `AGENTS.md`.** When both prescribe a command, follow this file exactly.
> It is user-maintained and reflects what the owner actually wants on this
> machine.

## Use `nh` instead of raw `nixos-rebuild` / `home-manager`

`nh` (github.com/nix-community/nh) is a CLI helper that wraps
`nixos-rebuild`, `home-manager`, and related tools. It is installed in
`environment.systemPackages` and `NH_FLAKE=/etc/nixos` is set system-wide
(`modules/apps/cli.nix`), so no path or `--flake` argument is ever needed.

**Why the owner prefers it:**

- Builds run as the regular user; only the final activation step needs
  `sudo` — `flake.lock` and the store stay user-owned.
- Shows a clean `nvd` diff (upgrades / downgrades / added / removed) on
  switch.
- `NH_FLAKE` means short commands: `nh os switch` instead of
  `sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)`.
- `nh clean` makes generation GC easier and safer.

**Command mapping — use the left column:**

| Task                     | Use (canonical)         | Raw equivalent (troubleshooting only)                     |
| ------------------------ | ----------------------- | --------------------------------------------------------- |
| Verify a config change   | `nh os test --dry`      | `nixos-rebuild dry-build --flake /etc/nixos#$(hostname)`  |
| Build + activate         | `nh os switch`          | `sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)`|
| Activate at next boot    | `nh os boot`            | `sudo nixos-rebuild boot --flake /etc/nixos#$(hostname)`  |
| Test without committing  | `nh os test`            | `sudo nixos-rebuild test --flake /etc/nixos#$(hostname)`  |
| Home Manager             | `nh home switch`        | `home-manager switch`                                     |
| Clean old generations    | `nh clean`              | —                                                         |

**Update everything:** `nix flake update` (re-resolves all `flake.lock`
inputs; unchanged by `nh`), then `nh os switch`.

**Troubleshooting fallback:** if `nh` fails in a way the message does not
explain, re-run the raw equivalent from the table to see the underlying
`nixos-rebuild` / nix pipeline directly. That is the only sanctioned use of
the raw forms.

**Home Manager note:** on this machine Home Manager is loaded as a NixOS
module, so `nh os test --dry` already covers it. Use `nh home switch` only
when the task is explicitly about the standalone home-manager flow.
