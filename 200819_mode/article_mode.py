
import time
import numpy as np
import pandas as pd
import seaborn as sns






x = [1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 6]

fig, ax = plt.subplots()
ax.hist(x,bins=np.arange(8) - 0.5, ec='white')
ax.set(xlabel='values', ylabel='Frequency', title='Distribution of x')
fig.savefig('hist.png')
#

# ------------------------------------------------------------
# statistics
# ------------------------------------------------------------
import statistics

# 最頻値のうち、出現した最初の値を返す@version3.8+
statistics.mode(x)

# 複数の最頻値を返したい場合はmodemulti()を使う
statistics.multimode(x)

# 複数の最頻値のうち最小の値のみを返す
min(statistics.multimode(x))

# ------------------------------------------------------------
# Scipy
# ------------------------------------------------------------
import scipy
mode, count = scipy.stats.mode(x)
mode[0]

# ------------------------------------------------------------
# numpy
# ------------------------------------------------------------
import numpy as np
uniqs, counts = np.unique(x, return_counts=True)
uniqs[counts == np.amax(counts)]

uniqs, counts = np.unique(x, return_counts=True)
uniqs[counts == np.amax(counts)].min()

# ------------------------------------------------------------
# Pandas
# ------------------------------------------------------------
# pandasで最頻値を求める
import pandas as pd
pd.Series(x, name='values').mode()
# 0    2
# 1    3
# 2    4
# dtype: int64

# 複数の最頻値のうち最小の値のみを返す
pd.Series(x, name='values').mode().min() # 2

# ------------------------------------------------------------
# Counter
# ------------------------------------------------------------
from collections import Counter

Counter(x).most_common()[0][0] # 2

# -------------------------------------------------------------
# 処理速度の比較
# -------------------------------------------------------------

# 比較する関数の設定
# 最頻値のうち最初の値を返す（statistics_modeのみ最小値を返す）
def mode_numpy(x):
    uniqs, counts = np.unique(x, return_counts=True)
    return uniqs[counts == np.amax(counts)][0]

methods = {
            'scipy': lambda x: scipy.stats.mode(x).mode[0],
            'numpy': mode_numpy,
            'statistics_multimode': lambda x: statistics.multimode(x)[0],
            # 'statistics_mode': lambda x: statistics.mode(x),
            'collections': lambda x: Counter(x).most_common()[0][0],
            'pandas': lambda x: pd.Series(x, name='values').mode().iloc[0]
            }


# 処理速度を計測（遅い）
np.random.seed(1234)
niter = 50
do_sort = False

# n_xs = [10, 1e2, 1e3, 1e4, 1e5, 1e6]

n_xs = np.arange(10, 10000, 1000)
results_list = []
for n_x in n_xs:
    # 対象の長さの1/3の種類数の乱数intを生成
    x = np.random.randint(n_x // 3, size=int(n_x))
    if do_sort:
        x = np.sort(x)
    for method, func in methods.items():
        ts = []
        for i in range(niter):
            start = time.time()
            mode = func(x)
            t = time.time() - start
            ts.append(t)
        mu = np.mean(ts)
        sd = np.std(ts)
        result = dict(n_x=n_x, method=method, mu=mu, sd=sd)
        results_list.append(result)

df_result = pd.DataFrame(results_list)


fig, ax = plt.subplots()
for k, d in df_result.groupby('method'):
    ax.plot(d['n_x'], d['mu'], label='{} mean'.format(k))
    ax.set(title='process time', xlabel='Length of x',
                ylabel='Elapsed time[sec]')
    ax.legend()
fig.savefig('result1.png')


cmap = plt.get_cmap('tab10')
gs = df_result.groupby('method')
nrows = gs.ngroups
fig, axes = plt.subplots(figsize=(8, 3 * nrows), nrows=nrows, ncols=1,
                            sharey=True)
for i, (ax, (k, d)) in enumerate(zip(axes, gs)):
    ax.errorbar(d['n_x'], d['mu'], yerr=d['sd'] / np.sqrt(niter),
                color=cmap(i), label='{} $\pm$1se'.format(k))
    ax.set(title='process time', xlabel='Length of x',
                ylabel='Elapsed time[sec]')
    ax.legend()
fig.tight_layout()
fig.savefig('result2.png')


