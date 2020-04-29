## %%
#'''
## Julia 變數 (Variables)、常數 (Constants) 與內建數學常數、與運算
#
### Day 005 作業：利用蒙地卡羅方法，估算圓周率
#
#蒙地卡羅方法 (Monte Carlo Method) 也稱為統計類比方法，可透過隨機分布的特徵數轉化為求解問題的答案，例如隨機數出現的機率。利用蒙地卡羅方法，估算圓周率的方式是藉由輸入隨機數來計算圓面積的過程，計算出圓周率 $\pi$。
#
#![](circle.png)
#
#假設有一個直徑長為 1 的圓形，要使用蒙地卡羅方法計算其面積，我們隨機塞入 N 個點到上面的正方形當中，有些點會落在圓形內而有些點會在圓形外，算出落在圓形內點的數目就可以得到圓形的面積。
#
#假設半徑為 $r$，圓形面積的計算公式為
#$$\pi r^2=\pi\times0.5^2=\frac{\pi}{4}$$
#
#並以此得到 $$\pi=4\times面積=4\times\frac{落在圓內的點}{所有的點}$$
'''

# %%
# 半徑長度
radius = 0.5

# %%
# 設定隨機數產生的數目
n = 100000

# %%
# 計算落在圓內點的數量
count = 0

# %%
#'''
#隨機產生兩個 0 到 1 之間的亂數以做為點的座標，並用迴圈計算及判斷點是否落在圓內 (迴圈及條件式的語法將會在 Day_007 詳細說明)
#
#[提示] 
#1. 隨機數的產生，請回顧 Day_004 的內容。
#2. 隨機點到中心點的距離，為 $\sqrt{(x-0.5)^2 + (y-0.5)^2}$，可以呼叫內建函式 `sqrt()` 開根號。
#'''
# %%
cx = 0.5
cy = 0.5
count = 0
using Debugger
for i = 1:n
    x = rand() 
    y = rand() 
    
    # 計算隨機點到中心點的距離，若距離小於半徑，表示點落在圓內
    dist = sqrt((x-cx)^2+(y-cy)^2) 
    if dist <= radius
        # ref: https://discourse.julialang.org/t/x-not-defined-error-even-though-it-is/20714/6
        # global scope issue
        global count += 1
    end
end

# %%
#'''
#估算出 $\pi$ 值
#'''
println("mypi = ", (count/n) / radius^2 )
# %%
#mypi = # 請將註解替換為程式

# %%
