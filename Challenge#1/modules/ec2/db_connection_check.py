import json
import http.server
import socketserver
import psycopg2
import boto3

region_name = "ap-south-1"

# Set up boto3 client
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)

# Fetch secret values from Secrets Manager
db_host = client.get_secret_value(SecretId='/challenge1/rds/hostname')['SecretString']
db_username = client.get_secret_value(SecretId='/challenge1/rds/username')['SecretString']
db_password = client.get_secret_value(SecretId='/challenge1/rds/password')['SecretString']

# Set up the HTTP server
class StatusHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/status':
            try:
                # Connect to the PostgreSQL database
                conn = psycopg2.connect(
                    host=db_host,
                    user=db_username,
                    password=db_password,
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
