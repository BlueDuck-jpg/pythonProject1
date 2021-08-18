import string
import random

print("".join(random.sample(string.ascii_lowercase, 5) + random.sample(string.digits, 3) + random.sample(string.punctuation, 2)))
