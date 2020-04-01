## %%
#'''
## Julia 套件管理 (Package Management)
#
### Day 003 作業
#
#在接下來的課程中，我們還會用到許多不同套件，請在今天的作業中先行安裝下列套件：`CSV.jl` （將會在資料操作的單元介紹）。
#'''
#
## %%
#'''
#### 指定安裝套件及版本
#
#今日作業請以 Functional API 模式進行套件安裝，並且指定安裝 0.5.26 版。
#
#安裝完成後請呼叫 `Pkg.installed()` 函式檢查已安裝的版本。
#'''
#
## %%
#
#
## %%
#'''
#### 不指定安裝版本
#'''

# %%
using Pkg
Pkg.add(PackageSpec(name="CSV", version="0.5.26"))
Pkg.installed()["CSV"]
#Pkg.add("CSV")

# %%
