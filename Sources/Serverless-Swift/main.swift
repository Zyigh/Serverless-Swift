import Foundation
import Kitura
import KituraCompression
import KituraStencil
import HeliumLogger

HeliumLogger.use()

let router = Router()
router.all(middleware: [StaticFileServer(), Compression()])
router.setDefault(templateEngine: StencilTemplateEngine())

router.get("/") {
    _, response, next in
    
    do {
//        try response.send("<html><body><h1>Hello</h1></body></html>").end()
        try response.render("index", context: [:]).end()
        next()
    } catch let e {
        print(e.localizedDescription)
        response.status(.internalServerError)
        next()
    }
}

Kitura.addHTTPServer(onPort: 80, with: router)
Kitura.run()
