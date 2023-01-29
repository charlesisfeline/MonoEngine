package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, currentLevel + '_high');
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}

class CustomPaths
{
	var dir:String = "";
	var lib:String = "";

	public function new(dir:String, lib:String)
	{
		this.dir = dir;
		this.lib = lib;
	}

	public function music(key:String, useFullDir = false)
	{
		return Paths.getPath('$dir/${useFullDir ? 'music/' : ''}$key.${Paths.SOUND_EXT}', MUSIC, lib);
	}

	public function sound(key:String, useFullDir = false)
	{
		return Paths.getPath('$dir/${useFullDir ? 'sounds/' : ''}$key.${Paths.SOUND_EXT}', SOUND, lib);
	}

	public function soundRandom(key:String, min:Int, max:Int, useFullDir = false)
	{
		return sound(key + FlxG.random.int(min, max), useFullDir);
	}

	public function txt(key:String, useFullDir = false)
	{
		return Paths.getPath('$dir/${useFullDir ? 'data/' : ''}$key.txt', TEXT, lib);
	}

	public function json(key:String, useFullDir = false)
	{
		return Paths.getPath('$dir/${useFullDir ? 'data/' : ''}$key.json', TEXT, lib);
	}

	public function image(key:String, useFullDir = false)
	{
		return Paths.getPath('$dir/${useFullDir ? 'images/' : ''}$key.png', IMAGE, lib);
	}

	public function getSparrowAtlas(key:String, useFullDir = false)
	{
		return FlxAtlasFrames.fromSparrow(image(key, useFullDir), Paths.file('$dir/${useFullDir ? 'images/' : ''}$key.xml', lib));
	}

	public function getPackerAtlas(key:String, useFullDir = false)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, useFullDir), Paths.file('$dir/${useFullDir ? 'images/' : ''}$key.txt', lib));
	}
}
