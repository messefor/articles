"""Simulate exponential data / gamma distribution with stan"""

import numpy as np
import scipy
import seaborn as sns
import matplotlib.pyplot as plt


scale = 1.0
shape = 1.0
size = 10000


fig, ax = plt.subplots()
for shape in np.arange(0., 50, 10):
    if shape > 0:
        data = np.random.gamma(shape=shape, scale=scale, size=size)
        mu = data.mean()
        label = 'shape={:.1f}, scale={:.1f}, mu={:.1f}'.format(shape, scale, mu)
        sns.kdeplot(data, ax=ax, label=label)
ax.legend()


shape = 1.0
fig, ax = plt.subplots()
for scale in np.arange(20, 50, 10):
    data = np.random.gamma(shape=shape, scale=scale, size=size)
    mu = data.mean()
    label = 'shape={:.1f}, scale={:.1f}, mu={:.1f}'.format(shape, scale, mu)
    sns.kdeplot(data, ax=ax, label=label)
ax.legend()

# --------------------------------------------------------------------
# Build toy data
# --------------------------------------------------------------------


b0 = 1.3
b1 = 0.5

x = np.arange(0, 10, 0.2)
mu = b0 + b1 * x

scale = 1
# mu = shape / rate
rate = 1
scale = 1 / rate
shape = mu

y = map(lambda x: np.random.gamma(shape=x, scale=scale, size=1), shape)

fig, ax = plt.subplots()
ax.plot(x, mu)
ax.scatter(x, list(y))

