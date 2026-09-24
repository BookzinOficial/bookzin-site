// Gera og.png (1200×630) — a imagem do link colado no WhatsApp, Instagram etc.
// Uso: swift tools/GerarOG.swift   (na pasta do site)
// Fontes e cores são as do app: Caprasimo nos títulos, Figtree no corpo, fundo creme.
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let raiz = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let fontes = URL(fileURLWithPath: "/Users/edu/workspace/bookzin/ios/App/Fontes")
for f in ["Caprasimo-Regular.ttf", "Figtree.ttf"] {
    CTFontManagerRegisterFontsForURL(fontes.appendingPathComponent(f) as CFURL, .process, nil)
}

let W = 1200, H = 630
let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
func cor(_ hex: UInt32, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255, alpha: a)
}
ctx.setFillColor(cor(0xF5EFE3)); ctx.fill(CGRect(x: 0, y: 0, width: W, height: H))

// Lombadas no canto direito, como na marca.
let lombadas: [(UInt32, CGFloat)] = [(0xEA9393, 300), (0xF4D38A, 360), (0x3C7286, 330), (0xEA9393, 280), (0xF4D38A, 340)]
var x: CGFloat = 820
for (c, h) in lombadas {
    ctx.setFillColor(cor(c))
    let r = CGRect(x: x, y: 150, width: 58, height: h)
    ctx.addPath(CGPath(roundedRect: r, cornerWidth: 12, cornerHeight: 12, transform: nil)); ctx.fillPath()
    x += 72
}

// O ícone do app.
if let fonte = CGImageSourceCreateWithURL(raiz.appendingPathComponent("icone-512.png") as CFURL, nil),
   let icone = CGImageSourceCreateImageAtIndex(fonte, 0, nil) {
    ctx.saveGState()
    let r = CGRect(x: 90, y: 420, width: 120, height: 120)
    ctx.addPath(CGPath(roundedRect: r, cornerWidth: 28, cornerHeight: 28, transform: nil)); ctx.clip()
    ctx.draw(icone, in: r)
    ctx.restoreGState()
}

func escrever(_ texto: String, fonte: String, tamanho: CGFloat, cor c: CGColor, em ponto: CGPoint, largura: CGFloat) {
    let f = CTFontCreateWithName(fonte as CFString, tamanho, nil)
    let atr = NSAttributedString(string: texto, attributes: [
        NSAttributedString.Key(kCTFontAttributeName as String): f,
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): c,
    ])
    let quadro = CTFramesetterCreateFrame(CTFramesetterCreateWithAttributedString(atr), CFRange(location: 0, length: 0),
                                          CGPath(rect: CGRect(x: ponto.x, y: ponto.y, width: largura, height: 400), transform: nil), nil)
    CTFrameDraw(quadro, ctx)
}
escrever("Bookzin", fonte: "Caprasimo-Regular", tamanho: 84, cor: cor(0x201E1D), em: CGPoint(x: 86, y: -40), largura: 700)
escrever("Terminou em 4 dias.\nO Bookzin conta pra você.", fonte: "Figtree-SemiBold", tamanho: 44,
         cor: cor(0x201E1D, 0.78), em: CGPoint(x: 90, y: -190), largura: 700)
escrever("Estante · séries em ordem · clube de leitura", fonte: "Figtree-Medium", tamanho: 28,
         cor: cor(0x3C7286), em: CGPoint(x: 90, y: -300), largura: 700)

let destino = CGImageDestinationCreateWithURL(raiz.appendingPathComponent("og.png") as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(destino, ctx.makeImage()!, nil)
print(CGImageDestinationFinalize(destino) ? "og.png gerado" : "falhou")
