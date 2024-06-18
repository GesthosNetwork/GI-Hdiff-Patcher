	[GI-Hdiff Patcher: a tool for updating Genshin Impact properly]
	[Author: Tom]
	
	If you update game by simply copying all the 'update files' and then
	replacing them in the game client directory, that's actually not the correct way.
	You should merge the .pck.hdiff update with the old .pck file and delete the obsolete files
	listed in deletefiles.txt

	How to use?
	For example, you wanna update game from 4.3.0 to 4.4.0
	1. Make sure you have extract all files from the 'game_4.3.0_4.4.0_hdiff.zip'
	   and 'en-us_4.3.0_4.4.0_hdiff.zip' and then replace to '4.3.0' game client directory.
	2. Drop hdiffz.exe,
			hpatchz.exe,
			Start.bat,
			Cleanup_4.3.0-4.4.0.txt,
			AudioPatch_Common_4.3.0-4.4.0.txt,
			AudioPatch_English_4.3.0-4.4.0.txt,
			AudioPatch_Japanese_4.3.0-4.4.0.txt,
			AudioPatch_Chinese_4.3.0-4.4.0.txt,
			AudioPatch_Korean_4.3.0-4.4.0.txt,
	   in the same folder as GenshinImpact.exe
	3. Run Start.bat, just wait until finished process.
	4. Now, your game is '4.4.0'
	
	# Note
	* Update version 1.0.0 - 1.4.0
	  From 1.0.0 to update 1.4.0, the game update includes voice audio packs for all languages.

	* Update version 1.5.0 - 2.4.0
	  Starting from the version update from 1.4 to 1.5, the developer separated between games update and voice audio packs update.

	* Update version 2.5.0 & 2.6.0
	  Starting from updating the version from 2.4 to 2.5, and from 2.5 to 2.6, the developer started changing the games update to hdiff.
	  To update the audio voice packs, it is still the same as before (non-hdiff).

	  So, hdiff is a piece of file data that need to be merged into the master file, so that after merging it will produce
	  master file with a new size larger than before.

	  Example:		Banks0.pck (59.5 mb)		// before update
					+	Banks0.pck.hdiff (3.0 mb)   // hdiff update
					------------------------------
					=	Banks0.pck (62.5 mb)		// new size after update

	* Update versi 2.7.0 - 4.5.0
	  Starting from updating version 2.6 to 2.7, until updating version 4.4 (current), the developer changed both of the games update
	  and the audio voice packs become hdiff.


	# reference
	- https://www.hoyolab.com/article/162549
	- https://github.com/sisong/HDiffPatch/releases
	- https://github.com/GamerYuan/GenshinPatcher
