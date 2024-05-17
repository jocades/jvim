import time


def loop():
    print(time.strftime("%H:%M:%S", time.localtime()), flush=True)
    time.sleep(1)
    loop()


if __name__ == "__main__":
    try:
        loop()
    except KeyboardInterrupt:
        print("Bye!")
