import os
from pymemcache.client import base
from flask import Flask

MEMCACHED_HOST = os.environ.get("MEMCACHED_HOST", "127.0.0.1")
MEMCACHED_PORT = os.environ.get("MEMCACHED_PORT", "11211")

APP_PORT = os.environ.get("APP_PORT", "3000")

APP = Flask(__name__)
CLIENT = base.Client((MEMCACHED_HOST, MEMCACHED_PORT))

KEY_ID = "visitors"


def b_to_i(val_b):
    val_s = val_b.decode()
    val_i = int(val_s)
    return val_i


def i_to_b(val_i):
    val_s = str(val_i)
    val_b = val_s.encode()
    return val_b


def inc_on_visit():
    try:
        while True:
            val_b, cas = CLIENT.gets(KEY_ID)
            if val_b is None:
                val_b = i_to_b(1)
            else:
                val_i = b_to_i(val_b)
                val_i += 1
                val_b = i_to_b(val_i)
            if CLIENT.cas(KEY_ID, val_b, cas):
                break
    except Exception as _e:
        CLIENT.set(KEY_ID, i_to_b(1))


def curr_val():
    val_b = CLIENT.get(KEY_ID)
    val_i = b_to_i(val_b)
    return val_i


@APP.route("/")
def hello():
    inc_on_visit()
    val = curr_val()
    return f"Current Value: {val}"


if __name__ == "__main__":
    APP.run(port=APP_PORT, host="0.0.0.0")
