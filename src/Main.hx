import db.Database;
import api.APIv1;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPServer;

class Main {
	public static final dev:Bool = true;

	private static var httpserver:HTTPServer;

	static function main() {
		trace("Checking database");
		var dbcheck = Database.check();
		trace("Checked database");
		if (!dbcheck) {
			trace("Initializing database");
			Database.init();
			trace("Initialized database");
		}
		trace("Starting HTTP Server");
		startHttpServer();
		trace("Started HTTP Server");
	}

	static function handleRequest(req:HTTPRequest) {
		var fullpath = req.methods[1].substr(1);
		var path = fullpath.split("?")[0];
		var paths = path.split("/");
		if (paths[0] == "api") {
			switch (paths[1]) {
				case "v1":
					APIv1.handle(req);
				default:
			}
		}
	}

	static function startHttpServer() {
		var port = 80;
		if (dev)
			port = 8000;
		httpserver = new HTTPServer("0.0.0.0", port);
		httpserver.onClientConnect = handleRequest;
	}
}
