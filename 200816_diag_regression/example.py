"""Regression diagnostics

Diagnostic for Leverage and Influence
http://home.iitk.ac.in/~shalab/regression/Chapter6-Regression-Diagnostic%20for%20Leverage%20and%20Influence.pdf

https://rpubs.com/mpfoley73/501093

Datasets Used in this Course
https://online.stat.psu.edu/stat501/node/1025

スチューデント化残差
https://ja.wikipedia.org/wiki/%E3%82%B9%E3%83%81%E3%83%A5%E3%83%BC%E3%83%87%E3%83%B3%E3%83%88%E5%8C%96%E6%AE%8B%E5%B7%AE
"""

import numpy as np
import seaborn as sns
from scipy import stats
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

scatter_kws = dict(facecolor='None', edgecolors='black')


def inverse_percentile(x):
    return np.argsort(np.argsort(x)) * 100. / (len(x) - 1)


def get_rounded(x, digit=10):
    m = np.floor(x.min() / digit) * digit
    M = np.ceil(x.max() / digit) * digit
    return np.arange(m, M, digit)


def get_fig_ax(ax):
    if ax is None:
        fig, ax = plt.subplots()
    else:
        fig = ax.get_figure()
    return fig, ax

def plot_true_vs_pred(y_true, y_pred, ax=None):
    # TODO: add grid
    # TODO: add, label
    fig, ax = get_fig_ax(ax)
    ax.scatter(y_true, y_pred, **scatter_kws)
    return fig, ax


def plot_res_fitted(y_true, y_pred, ax=None):
    # TODO: add grid
    # TODO: add, label
    res = y_true - y_pred
    fig, ax = get_fig_ax(ax)
    ax.scatter(y_pred, res, **scatter_kws)
    ax.axhline(0, color='black')
    return fig, ax

def plot_scale_loc(y_true, y_pred, ax=None):
    # TODO: add grid
    # TODO: add, label
    res = y_true - y_pred
    res_sqrt_std = np.sqrt(np.abs(res / np.std(res)))
    fig, ax = get_fig_ax(ax)
    ax.scatter(y_pred, res_sqrt_std, **scatter_kws)
    return fig, ax


def plot_qq(y_true, y_pred):

    fig, ax = get_fig_ax(ax=None)

    res = y_true - y_pred
    res_norm = res / np.std(res)

    percs_norm_cdf = stats.norm.cdf(res_norm)
    percs_res = inverse_percentile(res_norm)

    x_labels = np.arange(-2, 2, 0.5)
    x_label_values = stats.norm.cdf(x_labels)

    y_labels = get_rounded(y_pred, digit=10)
    # y_label_values = y_true - y_labels

    ax.scatter(percs_norm_cdf, percs_res)

    # ax.set_xticks(x_label_values)
    # ax.set_xticklabels(x_labels)

    # ax.set_yticks(y_label_values)
    # ax.set_yticklabels(y_labels)

    return fig, ax


def plot_leverage():

    # X'Xb = X'y
    # b = (X'X)^{-1}X'y
    # y = Xb = X(X'X)^{-1}y

    b = np.linalg.inv(X.T @ X) @ X.T @ y
    H = X @ np.linalg.inv(X.T @ X) @ X.T

    np.trace(H)
    np.linalg.matrix_rank(H)

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.heatmap(H, annot=True, fmt='.1f', ax=ax)


# -------------------------------------------------------

fname = 'STAT501_Lesson10/cement.txt'
data = np.loadtxt(fname, skiprows=1)

y = data[:, 0]
X = data[:, 1:]

n, k = X.shape

X = np.insert(X, 0, np.ones(n), axis=1)


model = LinearRegression(fit_intercept=False)
model.fit(X, y)
y_hat = model.predict(X)



# ---------------------------------------------------------------------
model.intercept_
model.coef_

fig, ax = plot_true_vs_pred(y, y_hat)

fig, ax = plot_res_fitted(y, y_hat)

fig, ax = plot_scale_loc(y, y_hat)

fig, ax = plot_qq(y, y_hat)



# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------


