
import PerfectHTTPServer

try? DB().createTable()

let server = HTTPServer()
server.documentRoot = "./webroot"
server.serverPort = 9191
RouteConfig.loadRoutes(server: server)
do {
    try server.start()
} catch {
    print(error.localizedDescription);
}
