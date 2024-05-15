import time


def loop(count=0):
    count += 1
    print(time.strftime("%H:%M:%S", time.localtime()), flush=True)
    time.sleep(1)
    loop(count)


if __name__ == "__main__":
    try:
        loop()
    except KeyboardInterrupt:
        print("Bye!")
