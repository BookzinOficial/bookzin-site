// O QR code do site, como SVG — gerado pelo próprio macOS (CoreImage), sem biblioteca nova.
// Uso: swift tools/GerarQR.swift https://bookzin.com.br/baixar qr-baixar.svg
//
// ⚠️ O QR aponta pra bookzin.com.br/baixar, NUNCA direto pra uma loja: o endereço da App
// Store só existe depois da aprovação e o Android ainda não tem app. Quem decide pra onde a
// pessoa vai é a página /baixar — o QR impresso (marcador, cartão) nunca precisa mudar.
import CoreImage
import Foundation

let args = CommandLine.arguments
guard args.count == 3 else { print("uso: swift GerarQR.swift <endereço> <saida.svg>"); exit(1) }
let endereco = args[1], saida = args[2]

let filtro = CIFilter(name: "CIQRCodeGenerator")!
filtro.setValue(Data(endereco.utf8), forKey: "inputMessage")
filtro.setValue("M", forKey: "inputCorrectionLevel")   // aguenta ~15% da imagem estragada
let imagem = filtro.outputImage!
let lado = Int(imagem.extent.width)

// Lê os módulos pixel a pixel (1 pixel = 1 módulo).
let contexto = CIContext()
var pixels = [UInt8](repeating: 0, count: lado * lado * 4)
contexto.render(imagem, toBitmap: &pixels, rowBytes: lado * 4,
                bounds: imagem.extent, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

// Um caminho só, um quadrado por módulo escuro. A margem (4 módulos, o que a norma pede)
// fica no viewBox, com fundo claro — em tema escuro o QR continua lendo.
var d = ""
for y in 0..<lado {
    for x in 0..<lado where pixels[(y * lado + x) * 4] < 128 {
        d += "M\(x) \(y)h1v1h-1z"
    }
}
let m = 4, total = lado + 2 * m
let svg = """
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-\(m) -\(m) \(total) \(total)" shape-rendering="crispEdges" role="img" aria-label="QR code para \(endereco)">
<rect x="-\(m)" y="-\(m)" width="\(total)" height="\(total)" fill="#FFFBF2"/>
<path fill="#201E1D" d="\(d)"/>
</svg>

"""
try! svg.write(toFile: saida, atomically: true, encoding: .utf8)
print("\(saida): \(lado)×\(lado) módulos → \(endereco)")
