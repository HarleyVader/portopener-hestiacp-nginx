import socket
import os

sock_path = '/home/brandynette/web/bambisleep.chat/js-lmstudio-sdk/app.sock'

# Remove the socket file if it already exists
if os.path.exists(sock_path):
    os.remove(sock_path)

# Create a Unix domain socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

# Bind the socket to the file
sock.bind(sock_path)

print(f"Socket created at {sock_path}")