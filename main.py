from src.transformator import transform


class Handler:
    def handle(self):
        train_transform,valid_transform,test_transform = transform()


def run():
    handler = Handler()
    handler.handle()


if __name__ == "__main__":
    run()
