from rich import print
from time import sleep
from pathlib import Path

p = Path("exec.py")


def main():
    print("Hello from main()")
    sleep(1)
    print(1+2)

    # print(1/0)


if __name__ == "__main__":
    main()
