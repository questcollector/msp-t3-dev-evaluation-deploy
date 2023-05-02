import os
import base64
import hashlib
import sys
import json

password = sys.argv[1]

def get_rabbit_password_hash(password):
    # generate 32 bit salt
    salt = os.urandom(4)  # 4 bytes = 32 bit
    # concatenate salt with utf-8 encoded password
    first = salt + password.encode('utf-8')
    # sha256 hash
    second = hashlib.sha256(first).digest()
    # concatenate salt again
    third = salt + second
    return base64.b64encode(third).decode()

if __name__ == '__main__':
    value = json.dumps({"hash": get_rabbit_password_hash(password)})
    print(value)