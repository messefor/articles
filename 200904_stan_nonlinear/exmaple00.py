"""Simulate exponential data / gamma distribution with stan"""

import numpy as np
import scipy
import seaborn as sns
import matplotlib.pyplot as plt


scale = 1.0
shape = 1.0
size = 100000


fig, ax = plt.subplots()
for shape in np.arange(0., 10, 2):
    if shape > 0:
        data = np.random.gamma(shape=shape, scale=scale, size=size)
        mu = data.mean()
        label = 'shape={:.1f}, rate={:.1f}, mu={:.1f}'.format(shape, 1/scale, mu)
        sns.kdeplot(data, ax=ax, label=label)
ax.legend()


shape = 3.0
fig, ax = plt.subplots()
for rate in np.arange(0.1, 1.0, .2):
    scale = 1 / rate
    data = np.random.gamma(shape=shape, scale=scale, size=size)
    mu = data.mean()
    # label = 'shape={:.1f}, rate={:.1f}, mu={:.1f}'.format(shape, 1/scale, mu)
    label = 'shape={:.1f}, rate={:.2f}'.format(shape, 1/scale)
    sns.kdeplot(data, ax=ax, label=label)
ax.set(xlim=(0, 20))
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

