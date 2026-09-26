# Kloggers' Arma 3 Missions

A personal collection of Arma 3 multiplayer missions — Zeus Game Master bases and build-your-base/fortification missions — for Altis, Livonia, and Tanoa. Use them as-is if you like, or edit them freely; the source is all here.

Packed into `.pbo` files for your local Arma 3 missions folder by [`pack.ps1`](#packing-with-packps1).

## Missions

| Mission | Map | Description |
| --- | --- | --- |
| `KloggersZeus.Altis` | Altis | Zeus Game Master base. Up to 50 players, with curator permission parameters and an optional co-op/DM `_PARAMTYPE` variant driven by `paramType.sqf`. |
| `KloggersZeus.Enoch` | Livonia | Zeus Game Master base. Up to 49 players. |
| `KloggersZeus.Tanoa` | Tanoa | Zeus Game Master base, same configuration as the Livonia version. |
| `KloggersAltisArsenal.Altis` | Altis | Build-your-base mission. ACE3 Fortify registers H-barriers, sandbags, and emplacements to all sides with an unlimited budget. |
| `KloggersLivoniaArsenal.Enoch` | Livonia | The same as the Altis Arsenal mission, on Livonia. |

Missions are named `Kloggers<Name>.<Map>`. The suffix names the terrain the scenario is built for, and `pack.ps1` produces a `.pbo` named after the folder verbatim — that name is what appears in the Arma 3 multiplayer server browser.

Note that all three `KloggersZeus.*/initServer.sqf` files are identical, as are the two Arsenal `initServer.sqf` files. Only `mission.sqm` and `description.ext` differ between maps, so a change to the shared logic only needs making once — edit one and copy it to the others.

## Requirements

- Arma 3, plus the maps your chosen missions are built on
- PowerShell 7 or later
- [PBO Manager](https://github.com/winseros/pboman3) installed, and available on your `PATH`

### PBO Manager setup

`pack.ps1` shells out to PBO Manager to do the actual packing, invoking it as `Start-Process "pbom"`. That means `pbom.exe` has to be resolvable on your `PATH` or the pack step will fail.

1. Install PBO Manager.
2. Add its install directory to your `PATH`. The default per-user install location is `C:\Users\<username>\AppData\Local\PBO Manager\`.
3. Open a **new** terminal. PowerShell only reads `PATH` when the session starts, so an already-open session will not see the change.
4. Confirm it resolves:

   ```powershell
   Get-Command pbom
   ```

Run `pack.ps1` from the root of this repository. PBO Manager packs relative to the current working directory, so it needs to be invoked from here to find the mission folder.

## Packing with `pack.ps1`

```
.\pack.ps1 <Mission> [-OutDir <path>] [-MaxBackups <int>]
```

| Parameter | Position | Default | Description |
| --- | --- | --- | --- |
| `Mission` | 0 (required) | — | Name of the mission folder in the repository root, e.g. `KloggersZeus.Altis`. Also determines the name of the resulting `.pbo`. |
| `OutDir` | 1 | `~/Documents/Arma 3/missions` | Where the `.pbo` is written and where backups are kept. The folder must already exist. |
| `MaxBackups` | 2 | `5` | How many timestamped backups to keep per mission. Use `-1` to keep every backup indefinitely. |

The script runs three stages, and stops with an error if any of them fails.

**1. Validation** — checks that the mission folder exists in the repository root, and that `OutDir` exists. Nothing is written if either check fails.

**2. Backup** — if `<OutDir>\<Mission>.pbo` already exists, it is copied to `<OutDir>\backup\<Mission>.pbo.<yyyyMMddHHmmss>.bak`, creating the `backup` folder if needed. Afterwards, older backups for that mission are pruned so that at most `MaxBackups` remain, newest first. Pass `-MaxBackups -1` to disable pruning. Only a pack that replaces an existing `.pbo` produces a backup, so the chain of history builds up as you work.

**3. Pack** — deletes the existing `.pbo`, then runs `pbom pack -o <OutDir> -u <Mission>`, and verifies the `.pbo` actually landed in `OutDir`.

### Examples

```powershell
# Defaults: packs to ~/Documents/Arma 3/missions, keeping 5 backups
.\pack.ps1 KloggersZeus.Altis

# Pack somewhere else and keep a longer history
.\pack.ps1 KloggersZeus.Altis -OutDir "D:\Arma3\missions" -MaxBackups 10

# Keep every backup forever
.\pack.ps1 KloggersAltisArsenal.Altis -OutDir "D:\Arma3\missions" -MaxBackups -1
```

## Backups

Backups live in a `backup` subfolder of `OutDir`, alongside the packed missions:

```
<OutDir>\backup\
├── KloggersZeus.Altis.pbo.20260926133922.bak
├── KloggersZeus.Altis.pbo.20260926011000.bak
└── KloggersAltisArsenal.Altis.pbo.20260926133711.bak
```

Each filename is the mission, the packed `.pbo`, and a `yyyyMMddHHmmss` timestamp. Pruning is tracked per mission, so packing one mission never evicts another mission's history.

To restore an older version, copy or rename the `.bak` file you want back to `<Mission>.pbo` in `OutDir`.

The `backup/` folder at the root of this repository is just the result of packing with the default `OutDir`, which is this directory. Along with `*.pbo` and `*.bak`, it is excluded from git — history lives in commits, backups are only for your local `.pbo` files.

## Adding a mission

1. Create a folder named `Kloggers<Name>.<Map>` in the repository root, containing at least `description.ext` and `mission.sqm` (add `initServer.sqf` or anything else you need alongside them).
2. Pack it like any other: `.\pack.ps1 Kloggers<Name>.<Map>`

## Layout

```
.
├── KloggersAltisArsenal.Altis/     # Altis build-your-base mission
├── KloggersLivoniaArsenal.Enoch/   # Livonia build-your-base mission
├── KloggersZeus.Altis/             # Altis Zeus mission
├── KloggersZeus.Enoch/             # Livonia Zeus mission
├── KloggersZeus.Tanoa/             # Tanoa Zeus mission
├── backup/                         # local backups (gitignored)
├── pack.ps1
└── LICENSE
```

## License

MIT — see [LICENSE](LICENSE).

The `mission.sqm` scenarios are derived from Bohemia Interactive's Zeus Game Master missions, which are covered by their own license.
