package api;

import db.Database;
import models.Report;
import haxe.Json;
import hx_webserver.HTTPRequest;

class APIv1 {
	public static function handle(req:HTTPRequest) {
		var fullpath = req.methods[1].substr(1);
		var path = fullpath.split("?")[0];
		var paths = path.split("/");
		switch (paths[2]) {
			case "report":
				var data:Report = Json.parse(req.postData);
				Database.setSpeeds(data.way, data.min_speed, data.avg_speed, data.max_speed);
				req.reply("Success", 200);
				return;
			case "get":
			default:
		}
	}
}
