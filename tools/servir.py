# Servidor local que imita o GitHub Pages: pasta/ → pasta/index.html, e o que não existe → 404.html.
# Uso: python3 tools/servir.py   (na pasta do site) → http://localhost:8088
import http.server, os
class Pages(http.server.SimpleHTTPRequestHandler):
    def send_error(self, code, message=None, explain=None):
        if code == 404 and os.path.exists("404.html"):
            corpo = open("404.html", "rb").read()
            self.send_response(404); self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(corpo))); self.end_headers(); self.wfile.write(corpo)
        else:
            super().send_error(code, message, explain)
http.server.ThreadingHTTPServer(("127.0.0.1", 8088), Pages).serve_forever()
