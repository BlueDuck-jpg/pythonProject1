import string
import random

nasi = string.ascii_lowercase
tibe = random.sample(nasi, 5)
tibegile = "".join(tibe)
print(tibegile)
