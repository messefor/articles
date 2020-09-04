venv + pyenvでの環境構築

一つのOS上で複数バージョンのPythonを切り替えるためのツール、`venv` +` pyenv`のメモです。今どきPythonバージョン3.3以上しか使うことないだろうということで、個人的に `venv` +` pyenv`の組み合わせで良と思います。本投稿では `venv` +` pyenv`を使う理由、用途および導入手順を整理します。余裕があれば`poetry`についても触れたいと思います。

>  実行環境 MacOS Mojava



# モチベーションと用途の整理

まずこれらのツールを導入する際の2つのモチベーションを整理します。たぶん`仮想環境`という言葉この2つを両方を含んでしまっているのが、混乱しやすい原因の一つと思います。

## 1.パッケージ環境の切り替え

一般にプロジェクトによって必要な外部パッケージ（ライブラリ）は異なります。例えば、画像系ではOpenCVを使うかもしれませんが、画像以外のプロジェクトではなかなか使わないでしょう。不必要なパッケージが多くインストールされている環境は好ましくないため、プロジェクトごとに必要最小限のパッケージがインストールされた環境を用意することになります。このプロジェクトごとのパッケージ環境を切り替えるためのツールの代表が`venv`です。

## 2.Pythonのバージョン切り替え

もうひとつのニーズとして、一つのOS上でPythonのバージョンを切り替えて使いたいことがあります。特に以前はPython2系を使っているプロジェクトも多かったため、Python3系とPython2系を切り替えて使う必要がしばしばありました（Googleも2系だったし）。それ以外でも一般に開発を行っていると細かいバージョンの切り替えが必要になります。このPythonインタプリタの切り替えを行うツールの代表が`pyenv`です。



## venvとpyenvの用途

使い手から見た`venv`と`pyenv`の主な役割を整理すると以下のようになります。下表にもあるように、これらの機能を提供するツールは他にも存在します。

| ツール | 用途                                                       | その他のツール                     |
| ------ | ---------------------------------------------------------- | ---------------------------------- |
| venv   | プロジェクトごとに異なるパッケージをインストールしたいとき | virtualenv,pyenv-virtualenv, conda |
| pyenv  | プロエジェクトごと異なるPythonのバージョンを使いたいとき   | virtualenv, conda                  |



## なぜ`venv` + `pyenv`か

どのツールを選ぶかは、主に次の要素に依存する気がします。

* 使いたいPythonのバージョン
* 使っているOS
* 好み

Python3.3以上では、パッケージ環境（仮想環境）の切り替えとして`venv`が標準で使えます。Pythonのバージョンを一つしか使ってない方はこの`venv`を使えば十分です。たとえばPythonはOSにインストールされた3.6を使って、プロジェクトによってパッケージ群だけ切り替えるケースがこれに当たります。開発しているわけでは無ければ、ほぼこれで事足りると思います。
同様に複数のPythonバージョンを切り替えたくなった場合でも、Python3.3以上のバージョンの切り替えであれば、`venv` に加えてPythonインタプリタ切り替えツールとして `pyenv`を使うのが良いと思います。私はこのケースに該当します。　一方でバージョン3.3未満のPythonを使う場合は`venv`が使えないので、`pyenv`+ `pyenv-virtualenv`を使うのが良いと思います。`pyenv-virtualenv`は`pyenv`のプラグインで、仮想環境の切り替え機能を提供します。

結局、ニーズに合わせて下表のようにまとまる気がします。

|                                              | Python3.3以上のみ使う | Python3.3未満も使う        |
| -------------------------------------------- | --------------------- | -------------------------- |
| パッケージ環境のみ切り替えたい               | `venv`                | `virtualenv`（？しらん）   |
| パッケージ環境とPythonバージョンを切替えたい | `pyenv`+`venv`        | `pyenv`+`pyenv-virtualenv` |

一昔前は、`pyenv`がWindowsに対応していなかったことと、データ分析界隈で`Anaconda`がよく使われていたこともあり、Windowsでは`conda`によるパッケージやインタプリタ切り替えを行っていました。現在は`pyenv-win`というのがあるらしく状況が変わっているようです。私も以前Windowsでは`Anaconda`を使っていましたが、環境が管理しにくい印象があって現在は使わなくなりました（というかWindowを使っていない）



# 導入と使い方

`venv` + `pyenv`で十分である。という勝手な結論を前提にそれらの導入方法と使い方を簡単に説明します。



## venvの導入

Python3.3以上では`venv`は標準ライブラリに含まれているので、導入はありません。

### venvの使い方

仮想環境の一般的な利用手順は次のようになります

1. プロジェクトごとに仮想環境を作成
2. 仮想環境に入る
3. 環境構築や開発を行う
   1. ライブラリのインストール、環境変数設定など
   2. コーディング、実行
4. 仮想環境を抜ける



#### 1. プロジェクトごとに仮想環境を作成

作成する前に、念のためシステムにインストールされているPythonのバージョンを確認しましょう。

```shell
# pythonのバージョン確認
$ python -V

>>> Python 3.8.5
```

ここでバージョンが3.3以降ならば問題ないのですが、それ以前だと`venv`は使えないので3.3以降をインストールする必要がありますので、インストール方法は"python3 インストール"とかでググってください。

バージョン3.3以上でしたら、pythonから`venv`モジュールを実行して仮想環境を作成します。このとき同時に仮想環境の情報を保存するためのディレクトリパスを指定します。

```shell
# .venv/というディレクトリに新しい仮想環境を構築
$ python -m venv .venv
```

ここでは`.venv`というディレクトリ名を指定しているので、上記コマンドを実行すると`.venv/`がカレントディレクトリに作成されます。

#### 2.仮想環境に入る

上で指定した`.venv/`内にある`activate`コマンドを使って仮想環境に入ります。仮想環境に入るとプロンプトの前に`(.venv)`という表示が現れるので、環境に入ったことが分かります。

```shell
# 仮想環境に入る
$ source .venv/bin/activate

# (.env)という表示がプロンプトの前に現れる
(.venv)$
```

現在の環境は作成したばかりのまっさらな仮想環境なので、外部パッケージは何もインストールされていません。ためにし`numpy`を呼び出してみるとエラーが出ることが分かります。

```shell
# pythonのインタラクティブモードに入る
(.venv)$ python

Python 3.8.5 (default, Aug 22 2020, 07:29:50)
[Clang 10.0.1 (clang-1001.0.46.4)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>

# numpy をインポートしてみるとエラーが出る
>>> import numpy as np  
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'numpy'
```



#### 3. 環境構築や開発を行う

このまっさらな環境に必要なパッケージをインストールし、コードを書いて、実行していきます。

### パッケージのインストール

パッケージのインストールは`pip`でできます。仮想環境に入った状態でインストールしたパッケージは仮想環境内のみで利用可能です。外の環境に影響を及ぼしません。

```shell
# numpyとjupyterをインストール
(.venv)$pip install numpy jupyter
```



### Pythonの実行

仮想環境に入った状態で、pythonを実行すれば良いです。ファイルを指定したりして、普通に実行してください。

```shell
# いつもどおりpythonを実行すれば良い
(.venv)$ python example.py
```



#### Jupyter notebookを使う

仮想環境に入った状態でjupyter notebookを立ち上げれば、パッケージ環境下でnotebookを走らせることができます。

```shell
(.venv)$ jupyter notebook
```



### 仮想環境をHydrogenで使う（kernelspecをインストール）

仮想環境に入った状態でkernelspecをインストールすれば、AtomのHydrogenや他のJupyter notebookからこの仮想環境を選択できるようになります。

```shell
(.venv)$python -m ipykernel install --user --name kernel_name
```



### 仮想環境を抜ける

`deactivate`コマンドで仮想環境から抜けられます。仮想環境に入った状態ならば、`deactivate`とだけ打てばOKです。プロンプトの前の表示こが普段どおりに戻れば、環境から抜けられています。

```shell
# 仮想環境に入る
(.venv)$ deactivate

# (.env)という表示がプロンプトが消える
$
```



## pyenvの導入

`pyenv`は環境変数`PATH`を必要に応じて変更することでPythonインタプリタを切り替えてくれます。pyenvのインストールは[pyenvのページ](https://github.com/pyenv/pyenv#basic-github-checkout)の手順とおりに行えば簡単にできます。

ここではGithub経由でインストール、bashを使っている環境を前提のみ本家ページから引用します。環境が異なる方は本家ページを見てください。

```shell
# pyenvのインストール。$HOME/.pyenvにcloneするのがおすすめ
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# 環境変数の設定
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile

# PATH挿入と自動補完の設定。 eval "$(pyenv init -)"がきちんと.bash_profileに記載されたか確認してね
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile

# シェルの再起動
exec "$SHELL"
```



### pyenvで複数のPythonのバージョンをインストール

複数バージョンをインストールしてみましょう。`pyenv install --list`で利用可能なPythonのバージョン一覧を確認できます。`anaconda`や`miniconda`もインストールできちゃうのが面白いですね。

```shell
# pyenvで利用可能なPythonバージョン一覧を確認
$ pyenv install --list

Available versions:
  2.1.3
  2.2.3
  2.3.7
  2.4.0
...
  3.8.3
  3.8.4
  3.8.5
  3.9.0b5
  3.9-dev
  3.10-dev
  activepython-2.7.14
  activepython-3.5.4
  activepython-3.6.0
  anaconda-1.4.0
  anaconda-1.5.0
  anaconda-1.5.1
...
```

ここでは`3.8.3`をインストールしてみたいと思います。ちょっと時間がかかります。



```shell
# Python3.8.3をインストール
$ pyenv install 3.8.3
```

インストール完了後、`pyenv versions`とすれば、インストールされているPythonインタプリタ一覧が確認できます。

`3.8.3`がインストールされているのが確認できます。 `*` マークがついているのが現在設定されているPythonのバージョンです。`system`というのは元からシステムにインストールされている`python`コマンドを表します。

```shell
# インストールされているPython一覧を確認する
$ pyenv versions
* system (set by /Users/daisuke/.pyenv/version)
  3.8.3
```

### pyenvで複数のPythonのバージョンを切り替え

いくつか方法があるのですが、ここでは現在のシェルで一時的にバージョンを切り替える方法`pyenv shell`のみ記載します。特定のバージョン（例えば、`3.8.3`）に切り替えたい場合は、`pyenv shell 3.8.3`で可能です。元のバージョンに戻りたいときは、shellを終了するか、同じコマンドで`system`を指定すれば良いかと思います。

```shell
# バージョン3.8.3に切り替える
$ pyenv shell 3.8.3

＃ 現在のバージョンを確認する
$ pyenv version
3.8.3 (set by PYENV_VERSION environment variable)

# バージョン3.8.3から元にもどす
$ pyenv shell system
```



# venv + pyenvで様々なバージョンの仮想環境を構築する

今回これを書きたかっただけなのですが、前置きが長かった。。。。

`ven`+`pyenv`を使って、バージョン`3.8.3`で新しい仮想環境（パッケージ環境）を構築したいときは以下のようにします。ただ構築したいPythonのバージョンに切り替えて、仮想環境を作成するだけです。

```shell
# pyenvでPythonバージョンを切り替える
$ pyenv shell 3.8.3

# venvで新しい仮想環境を構築
$ python -m venv .venv
```

これにより、`.venv/`に指定のPythonバージョンでの仮想環境が構築されます。実際に仮想環境に入って実際に確認すると意図通りのPythonバージョンに設定されていることが分かります。

```shell
# 仮想環境に入る
$ source .venv/bin/activate

# 仮想環境内のPythonのバージョン確認
(.venv)$ python -V
Python 3.8.3
```



ちなみに仮想環境内のPythonインタプリタと`pyenv shell`した直後のPythonインタプリタは同じバージョン（3.8.3）ですが、仮想環境構築後に実行しているPythonコマンドは別物になります。

下記のように仮想環境内では`.venv/`の中にインストールされたPythonインタプリタを参照しています。

```shell
# 仮想環境のPythonは.venv/内のpythonを見にいっている
(.evn)$ which python
/Users/messefor/prj/blog200822/.venv/bin/python
```

一方で`pyenv shell`による切り替え直後は`pyenv`によってPATHに挿入されたPythonインタプリタを参照しています。`shims`というのが`pyenv`によって挿入された参照先になります

```shell
$ pyenv shell 3.8.3

$ which python
/Users/messefor/.pyenv/shims/python
```



----



実際には`venv`や`virtualenv`が提供するのは`仮想環境切り替え`で、Pythonインタプリタなども含めた環境を指しているかと思いますが、ここでは`パッケージの切り替え`、`Pythonバージョンの切り替え`の二つで分類しています。



