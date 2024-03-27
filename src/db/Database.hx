package db;

import haxe.io.Path;
import haxe.Json;
import sys.io.File;
import models.DbFile;
import sys.FileSystem;

class Database {
	public static final path:String = "./run/db.json";

	public static function check():Bool {
		if (FileSystem.exists(path))
			return true;
		return false;
	}

	public static function init() {
		if (check())
			return;
		var db:DbFile = [];
		var dir = Path.directory(path);
		FileSystem.createDirectory(dir);
		File.saveContent(path, Json.stringify(db));
	}

	private static function initWay(way:Int) {
		var db:DbFile = Json.parse(File.getContent(path));
		for (v in db) {
			if (v.way == way)
				return;
		}
		db.push({
			way: way,
			avg_speed: 0.0,
			max_speed: 0.0,
			min_speed: 0.0
		});
		File.saveContent(path, Json.stringify(db));
	}

	public static function setSpeeds(way:Int, min:Float, avg:Float, max:Float) {
		initWay(way);
		var db:DbFile = Json.parse(File.getContent(path));
		for (i in 0...db.length) {
			var v = db[i];
			if (v.way != way)
				continue;
			var cmin = v.min_speed;
			var cmax = v.max_speed;
			var cavg = v.avg_speed;
			db[i].min_speed = (cmin + min) / 2;
			db[i].max_speed = (cmax + max) / 2;
			db[i].avg_speed = (cavg + avg) / 2;
		}
		File.saveContent(path, Json.stringify(db));
	}
}
