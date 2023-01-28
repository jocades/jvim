from string import ascii_lowercase
import time


def main():
    for letter in ascii_lowercase[:5]:
        print(letter)
        time.sleep(1)

    print('Done!')

    # Create error, it should be caught
    # by vim.api.jobstart's stderr callback
    print(1 / 0)


if __name__ == '__main__':
    main()
