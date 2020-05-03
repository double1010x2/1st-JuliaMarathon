# %%
#'''
## Day 013 作業1：用 Julia 標準函式寫 Sigmoid Function

#在 Day 002 時我們曾用 LaTeX 撰寫機器學習常見的激活函式 Sigmoid
#
#$\Large f(x)=\frac{1}{1+e^{-x}}$
#
#作業 1 請使用內建函式 `exp()` 來撰寫 Sigmoid 函式，計算矩陣的 sigmoid 值。
#'''
#
## %%
#'''
#例如：數字 3 的 sigmoid 值。
#'''
#
## %%
#1 / (1 + exp(-3))
#
## %%
#'''
#宣告及建立矩陣
#'''
#
## %%
A = Matrix([1. 10. 3. 4. 6.; 4. 2. 4. 5. 10.; 8. 5. 3. 5. 9.])

# %%
# 請在此撰寫計算 sigmoid
function sigmoid(x)
    if ndims(x) <= 1
        return 1. / (1. + exp(-x))
    else
        for i in eachindex(x)
          x[i] = sigmoid(x[i])
        end
        return x
    end
end

println("sigmoid(3) = $(sigmoid(3))")
println("sigmoid(A) = $(sigmoid(A))")

# %%
# 請在此撰寫計算 sigmoid
function sigmoid(x)
    if ndims(x) <= 1
        return 1. / (1. + exp(-x))
    else
        for i in eachindex(x)
          x[i] = sigmoid(x[i])
        end
        return x
    end
end

# %%
'''
### 作業2：線性代數基礎運算 Matrix Multiplication 及 Addition
#
#假設 A 是 $n\times m$ 的矩陣，B 是 $m\times p$ 的矩陣，則矩陣乘法的積 AB 是 $\displaystyle n\times p$ 的矩陣。
#
# %%
'''
### 作業2：線性代數基礎運算 Matrix Multiplication 及 Addition
#
#假設 A 是 $n\times m$ 的矩陣，B 是 $m\times p$ 的矩陣，則矩陣乘法的積 AB 是 $\displaystyle n\times p$ 的矩陣。
#
#作業2 請撰寫程式，隨機產生矩陣 $W$ 及 $X$，計算線性方程式 $WX+b$。
#
#【提示】點運算的介紹，可回顧 Day 005 內容及範例。
#'''
#
## %%
## 給定 bias 變數值
## 這邊給定的是純量，在矩陣加法中透過 broadcasting 進行加法
b = 1
#
## %%
n = 3
m = 5
p = 13
w = rand(n,m) 
x = rand(m,p)
result = w*x .+ b
println("wx+b = $(result)")
#
## %%
#X = # 請在此撰寫程式
#
## %%
## 請在此撰寫計算線性方程式


# %%
