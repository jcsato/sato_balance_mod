# Sato's Balance Mod

A mod for the game Battle Brothers ([Steam](https://store.steampowered.com/app/365360/Battle_Brothers/), [GOG](https://www.gog.com/game/battle_brothers), [Developer Site](http://battlebrothersgame.com/buy-battle-brothers/)).

## Table of contents

-   [Features](#features)
-   [Requirements](#requirements)
-   [Installation](#installation)
-   [Uninstallation](#uninstallation)
-   [Compatibility](#compatibility)
-   [Building](#building)

## Features

Rebalances a number game elements, particularly weapons, that I felt were out of sync with the game's overall design. Any balance change in a game as tightly balanced as Battle Brothers will likely be controversial, so I don't expect these to appeal to everyone - but, for what it's worth, every change comes from a conversation I've had with the devs or beta testers and has gone through at least a couple rounds of polish and iteration.

This mod doesn't touch enemies themselves - for that, look at my [enemy rebalance mod](https://github.com/jcsato/sato_enemy_balance_mod).

**Named Weapons:**
- Named Weapon armor penetration now rolls +6-12% (down from +8-16%)
- Named Weapon armor effectiveness now rolls +15-35% (up from 10-30%)
- Named Weapons will no longer roll for reduced Fatigue on equip at all (reduced Fatigue build up on skill use is still possible)

**Perks:**
- Dagger Mastery now reduces the hit malus of Puncture to -10 (from -15)
- Sword Mastery no longer removes the hit malus of Riposte, instead granting +5 Melee Defense while Riposting if the offhand is free
- Lone Wolf now grants a +10% stat bonus at 2 tiles distance from allies (down from a +15% stat bonus at 3 tiles of distance)
- Taunt costs 10 Fatigue (down from 15)
- Rotation costs 20 Fatigue (down from 25)
- Footwork costs 18 Fatigue (down from 20)

**Retinue:**
- Instead of increasing your speed by 15% on all terrain, the Scout now reduces the speed penalty of "rough terrain" (forests, swamps, etc. and not snow or desert) by 15%. By way of example: in vanilla, the player moves 7.5% faster on swamps, 9.75% faster on forests, and 15% faster on plains with the Scout. With this change, they'd now move 15%, 15%, and 0% faster. Also, he's been renamed to "the Guide" to better reflect his function.

**Traits:**
- Brute grants +35% damage on head hits (up from +15%)
- Cocky grants +10 Resolve (up from +5)
- Tiny reduces Melee Damage by -10% (up from -15%)

**Tryout:**
- Tryout now grants increased mood and +10% XP Gain for 2 days

**Armor:**
- Gladiator Helmets now have 220/-12 Durability/Fatigue (from 225/-13)

**Weapons:**
- Handgonnes now deal 40-70 (from 35-75)
- Greatswords now deal 85-105 damage at 30% armor penetration (up from 85-100 at 25%)
- Heavy Rusty Axes now deal 70-90 damage (down from 75-90)
- Woodcutter's Axes now deal 50-75 damage (up from 35-70)
- Goblin bolas, bows, daggers, spears, and swords have an innate -3 Fatigue build up on skill use
- Javelins now have 3 ammo per stack
- Throwing Axes now have 4 ammo per stack
- The Aimed Shot skill of Bows now deals an additional +15% damage and has +15% to hit (up from +10% to both)
- The Lunge skill of Fencing Swords now caps (and scales) at 160 Initiative (down from 175) and can no longer deal below 100% of its damage

**Miscellaneous:**
- Bandages can now be used while engaged in melee
- Using bandages on a character confers the new "Vulnerable" status effect, which reduces Melee and Ranged defense by 10 for a turn
- Antidotes now last for 10 turns (up from 3)
- The War Wolf now has 50/30 innate body/head armor

## Requirements

1) [Modding Script Hooks](https://www.nexusmods.com/battlebrothers/mods/42) (v20 or later)

## Installation

1) Download the mod from the [releases page](https://github.com/jcsato/sato_balance_mod/releases/latest)
2) Without extracting, put the `sato_balance_*.zip` file in your game's data directory
    1) For Steam installations, this is typically: `C:\Program Files (x86)\Steam\steamapps\common\Battle Brothers\data`
    2) For GOG installations, this is typically: `C:\Program Files (x86)\GOG Galaxy\Games\Battle Brothers\data`

## Uninstallation

1) Remove the relevant `sato_balance_*.zip` file from your game's data directory

## Compatibility

This should be fully save game compatible, i.e. you can make a save with it active and remove it without corrupting that save.

This should be fairly compatible with other mods, except where obvious (e.g. mods that change the same thing).

### Building

To build, run the appropriate `build.bat` script. This will automatically compile and zip up the mod and put it in the `dist/` directory, as well as print out compile errors if there are any. The zip behavior requires Powershell / .NET to work - no reason you couldn't sub in 7-zip or another compression utility if you know how, though.

Note that the build script references the modkit directory, so you'll need to edit it to point to that before you can use it. In general, the modkit doesn't play super nicely with spaces in path names, and I'm anything but a batch expert - if you run into issues, try to run things from a directory that doesn't include spaces in its path.

After building, you can easily install the mod with the appropriate `install.bat` script. This will take any existing versions of the mod already in your data directory, append a timestamp to the filename, and move them to an `old_versions/` directory in the mod folder; then it will take the built `.zip` in `dist/` and move it to the data directory.

Note that the install script references your data directory, so you'll need to edit it to point to that before you can use it.
