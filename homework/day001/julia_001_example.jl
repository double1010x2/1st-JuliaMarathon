# %%
'''
# Julia 安裝及簡介


## 1. 查看 Julia 安裝版本及系統資訊

呼叫 `versioninfo()` 互動式工具 (Interactive Utilities) 函式 (Function)

確認 Julia, IJulia 環境安裝成功，並顯示 Julia 版本以及系統資訊
'''

# %%
versioninfo()

# %%
'''
## 2. Hello Julia

第一個 Julia 程式：透過 `println` 函式，印出 Hello Julia 字串
'''

# %%
println("Hello Julia")

# %%
'''
## 3. 套件管理

使用內建的套件管理 (Package Management) 工具，查看目前已安裝的套件及版本。
'''

# %%
using Pkg

Pkg.installed()

# %%
'''
## 安裝套件

試著用 Pkg 安裝新的套件

在這邊我們安裝 DataFrames 套件，會在之後的課程中用到
'''

# %%
Pkg.add("DataFrames")

# %%
'''
## 移除套件
'''

# %%
Pkg.rm("DataFrames")

# %%
'''
## 4. 內建函式 include

透過 include 來執行 (或包含) 既有的 Julia 程式

在 "hello_julia.jl" 程式裡面，程式內容是列印字串
```julia
println("Hello Julia")
```
'''

# %%
include("hello_julia.jl")

# %%
