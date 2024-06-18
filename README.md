# GI-Hdiff Patcher: a tool for updating Genshin Impact properly
**Author: Tom**

If you update the game by simply copying all the *update files* and then replacing them in the game client directory, that's actually not the correct way. You should merge the `.pck.hdiff` update with the old `.pck` file and delete the obsolete files listed in `deletefiles.txt`.

## How to use?

For example, you want to update the game from 4.3.0 to 4.4.0:

1. Make sure you have extracted all files from the `game_4.3.0_4.4.0_hdiff.zip` and `en-us_4.3.0_4.4.0_hdiff.zip`, then replace them in the `4.3.0` game client directory.
2. Place the following files in the same folder as `GenshinImpact.exe`:
   - `hdiffz.exe`
   - `hpatchz.exe`
   - `Start.bat`
   - `Cleanup_4.3.0-4.4.0.txt`
   - `AudioPatch_Common_4.3.0-4.4.0.txt`
   - `AudioPatch_English_4.3.0-4.4.0.txt`
   - `AudioPatch_Japanese_4.3.0-4.4.0.txt`
   - `AudioPatch_Chinese_4.3.0-4.4.0.txt`
   - `AudioPatch_Korean_4.3.0-4.4.0.txt`
3. Run `Start.bat` and wait until the process finishes.
4. Now, your game is updated to version `4.4.0`.

## Note

- **Update version 1.0.0 - 1.4.0**
  - From version 1.0.0 to 1.4.0, the game updates include voice audio packs for all languages.
- **Update version 1.5.0 - 2.4.0**
  - Starting from version 1.4 to 1.5, the developer separated game updates from voice audio pack updates.
- **Update version 2.5.0 & 2.6.0**
  - From version 2.4 to 2.5, and 2.5 to 2.6, the developer started using hdiff for game updates. Audio voice packs still used the old update method (non-hdiff).
  - Example:
    ```
    Banks0.pck (59.5 MB)        // before update
    + Banks0.pck.hdiff (3.0 MB) // hdiff update
    -----------------------------
    = Banks0.pck (62.5 MB)      // new size after update
    ```
- **Update version 2.7.0 - 4.5.0**
  - Starting from version 2.6 to 2.7 until the current version 4.4, the developer switched to using hdiff for both game updates and audio voice packs.

## Reference
- [https://www.hoyolab.com/article/162549](https://www.hoyolab.com/article/162549)
- [https://github.com/sisong/HDiffPatch/releases](https://github.com/sisong/HDiffPatch/releases)
- [https://github.com/GamerYuan/GenshinPatcher](https://github.com/GamerYuan/GenshinPatcher)
