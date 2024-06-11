def run():
    for i in range(1000):
        yield i

        if i > 1000:
            return
