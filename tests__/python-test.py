import random

# TODO: add some code here


def greet(text):
    return f'Hello {text}'


ls = [n for n in range(10) if n % 2 == 0]

print(ls)


def rest(n: int) -> int:
    return n + 1


dic = {
    'h': [0, 1, 2, 3, 4, 5,]
}

just_testing = random.choice(dic['h'])
print(just_testing)


class Test:
    count = 0

    def __init__(self, name):
        self.name = name
        Test.count += 1

    def __str__(self):
        return self.name


t = Test('test')
print(Test.count, t)
