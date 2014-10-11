variables - 変数バンク
========================================

これはなにか
----------------------------------------

これは伺か用SHIORIサブシステムである美代(Miyo)の辞書フィルタプラグインです。

栞で使う変数を管理するための名前と機能を提供します。

インストール
----------------------------------------

### 一般

    npm install miyojs-filter-variables

### ゴーストに追加する場合

ghost/masterをカレントディレクトリとして同様に

    npm install miyojs-filter-variables

含まれるフィルタ
----------------------------------------

### variables_initialize

初期化のためのフィルタです。

### variables_load

変数を読込みます。

### variables_save

変数を保存します。

依存
----------------------------------------

このフィルタが依存するものはありません。

使用方法
----------------------------------------

### 初期化

Miyoの辞書ファイルのエントリにvariables_initializeフィルタを追加します。

    _load:
    	filters: [..., variables_initialize, ...]
    	argument:
    		...

このフィルタの全機能はvariables_initializeを実行した後に利用できます。

### variables

Miyoのインスタンスにvariablesプロパティがセットされます。

variablesは単なるオブジェクトで、連想配列のように使って変数を格納できます。

    miyo.variables.hoge = 'piyo';

variablesはvariables_save、variables_loadで保存、復帰することを前提とした永続的な変数を保存する目的で使用します。

### variables_temporary

Miyoのインスタンスにvariables_temporaryプロパティがセットされます。

variables_temporaryは単なるオブジェクトで、連想配列のように使って変数を格納できます。

    miyo.variables_temporary.hoge = 'piyo';

variables_temporaryは保存、復帰を前提としない実行時変数を保存する目的で使用します。

# variables_save

Miyoのインスタンスにvariables_saveメソッドが追加されます。

またフィルタからも同機能を呼ぶことが出来ます。

variables_saveはファイル名を引数に取り、そのファイルへ変数を保存します。

    miyo.variables_save('./variables.save');
    
    OnSave:
    	filters: [variables_save]
    	argument:
    		variables_save: ./variables.save

# variables_load

Miyoのインスタンスにvariables_loadメソッドが追加されます。

またフィルタからも同機能を呼ぶことが出来ます。

variables_loadはファイル名を引数に取り、そのファイルから変数をロードします。

variables_saveでセーブされたファイルを扱えます。

    miyo.variables_load('./variables.save');
    
    OnSave:
    	filters: [variables_load]
    	argument:
    		variables_load: ./variables.save
