# %%
'''
# Julia 數值系統介紹

## Day 004 作業

#今天的內容提到整數及浮點數型別之最小值和最大值：
#
#|是否有正負號|型別|<div style="width:120px">最大值</div>|<div style="width:120px">最小值</div>|
#|---|---|---|---|
#|有|Int128, Int64, Int32, Int16, Int8|$2^{位元數-1}-1$|$-2^{位元數-1}$|
#|無|UInt128, UInt64, UInt32, UInt16, UInt8|$2^{位元數}-1$|$0$|
#
#|型別|最小值|最大值|
#|---|---|---|
#|`Float64`|-Inf|Inf|
#|`Float32`|-Inf 或 -Inf32|Inf 或 Inf32|
#|`Float16`|-Inf 或 -Inf16|Inf 或 Inf16|

### 作業：範例程式示範了 Int64 及 Float64 的最小值和最大值，作業請列出並觀察其他整數及浮點數型別的最小值和最大值。
#呼叫 `typemin()` 及 `typemax()` 函式得到各型別的最小值和最大值。
#
#列出 Int128, Int32, Int16, Int8, UInt128, UInt64, UInt32, UInt16, UInt8 整數型別的最小值及最大值
#'''
#
## %%
#
#
## %%
#'''
#列出 Float32, Float16 浮點數型別的最小和最大值
#'''
#
## %%
#
#
## %%
x = Dict("Int128"   =>Int128,
         "Int32"    =>Int32,
         "Int16"    =>Int16,
         "Int8"     =>Int8,
         "UInt128"  =>UInt128,
         "UInt64"   =>UInt64,
         "UInt32"   =>UInt32,
         "UInt16"   =>UInt16,
         "UInt8"    =>UInt8,
         "Float32"  =>Float32,
         "Float16"  =>Float16,
         )
for (key, val) in x
    println(key); 
    println(" typemin =", typemin(val))
    println(" typemax =", typemax(val))
end
