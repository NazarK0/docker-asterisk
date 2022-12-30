import argparse
import os
import sys
from time import sleep
import psycopg2

host="db"
db="asterisk"
user="admin"
password="jtyuajrqwzdl"
delay=2 

def postgres_test(db, user, host, password):
    print(db)
    print(user)
    print(host)
    print(password)
    try:
        conn = psycopg2.connect(f"dbname={db} user={user} host={host} password={password} connect_timeout=1 ")
        conn.close()
        return True
    except Exception as e:
        print(e)
        return False

def docker_executor(command):
    os.system(" ".join(command))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='Wait For Postgres',
        description='Wait until Postgres database is ready, then run commands (for example, docker container)',
        epilog='https://github.com/NazarK0')
    
    parser.add_argument('filename')
    parser.add_argument('-s', '--host', required=True, help='database host')
    parser.add_argument('-p', '--port', nargs=1, help='database port')
    parser.add_argument('-t', '--timeout', nargs=1, type=int, help='time for waiting if no connection')
    parser.add_argument('-c', '--command', required=True, nargs=1, help='commands to run if connection established')
    parser.set_defaults(port='5432')
    parser.set_defaults(timeout='2')

    args = parser.parse_args(sys.argv)
    
    while(True):
        if postgres_test(db, user, args.host, password):
            print("Postgres is up - executing command")
            docker_executor(args.command)
            break
        else:
            print("Postgres is unavailable - waiting...")
            sleep(args.timeout)
            continue