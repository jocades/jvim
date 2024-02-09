from rich import print
from time import sleep


def main():
    print(f'Hello from {__name__}')
    sleep(1)
    print(f'File: {__file__}')

    # ERROR OUT
    # print(1/0)


if __name__ == "__main__":
    main()
