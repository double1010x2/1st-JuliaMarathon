# %%
#'''
## Julia 函式 (Functions)
#
### 作業 006：身高體重指數 (Body Mass Index; BMI) 計算機
#
#身高體重指數 (Body Mass Index; BMI) 是我們常用來衡量健康的指標之一，例如肥胖是否為某一種疾病的致病原因。請用 Julia 函式撰寫 BMI 計算公式，並呼叫函式計算 BMI 值。
#
#BMI 計算公式：
#$$BMI=\frac{體重}{身高^2}$$
#其中體重的單位為公斤，身高的單位為公尺。
#'''

# %%
# 定義函式，並在函式中計算 BMI
function BMI(weight::Float64, height::Float64)::Float64
    return weight / height^2
end
# %%
# 呼叫上面定義的函式，得到計算出來的 BMI
println("man with weight=60, height=170, BMI=$(BMI(60., 1.7))")

# %%
# 可再次呼叫上面定義的函式，計算其他人的 BMI
println("woman with weight=50, height=160, BMI=$(BMI(50., 1.6))")


# %%
