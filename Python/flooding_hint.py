'''
you may also use this as the starter hint on flooding algorithm
this is not the real flooding, since we don't use asyncio here
but the algorithm should be basically as simple as this
hint: probably consider OTHER ways than using Kid.secrets for keeping track of who knows the secret
'''
from collections import defaultdict

class Kid:
    secrets = defaultdict(set)
    def __init__(self, name):
        self.name = name
        self.known_secret = list()
        self.friends = list()
    def __call__(self):
        print("{}'s secrets:".format(self.name))
        for i,secret in enumerate(self.known_secret):
            print("{})\t{}".format(i,secret))
    def befriend(self, other, mutual=True):
        self.friends.append(other)
        if mutual:
            other.friends.append(self)
    def known(self, message):
        return self.name in Kid.secrets[message]
    def share(self, message):
        if not self.known(message):
            self.known_secret.append(message)
            Kid.secrets[message].add(self.name)
            for friend in self.friends:
                friend.share(message)
    def hear(self, message):
        self.share(message)


if __name__ == '__main__':
    alice = Kid('Alice')
    bob = Kid('Bob')
    cathy = Kid('Cathy')
    alice.befriend(bob)
    alice.befriend(cathy)
    bob.befriend(cathy)

    alice.share("The King has ears shaped like a donkey!")
    bob.share("There's a silver nutmeg and a golden pear on my little nut tree.")

    print(Kid.secrets)

    cathy()


