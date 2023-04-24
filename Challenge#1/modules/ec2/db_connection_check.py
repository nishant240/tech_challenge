import json
import http.server
import socketserver
import psycopg2
import argparse

# Set up command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("db_host", help="database host URL")
parser.add_argument("db_username", help="database username")
parser.add_argument("db_password", help="database password")
args = parser.parse_args()

# Set up the HTTP server
class StatusHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/status':
            try:
                # Connect to the PostgreSQL database
                conn = psycopg2.connect(
                    host=args.db_host,
                    user=args.db_username,
                    password=args.db_password,
                    port=5432,
                    database='postgres'
                )
                # Return a JSON response if the connection is successful
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                response = {'status': 'up'}
                self.wfile.write(bytes(json.dumps(response), 'utf-8'))
                conn.close()
            except psycopg2.Error as e:
                # Return a 500 error if the connection fails
                self.send_error(500, message='Database connection failed')
        else:
            # Return a 404 error for any other requests
            self.send_error(404, message='Not Found')

PORT = 8080
with socketserver.TCPServer(("", PORT), StatusHandler) as httpd:
    print("Server listening on port", PORT)
    httpd.serve_forever()
