# %%
#'''
## 集合 (Collection) 型別：元組 (Tuple) 、Pair、字典 (Dict)、與 Set
#
### Day 010 作業：計算字串中各宇元出現的次數
#
#今天的作業請大家計算字串中，各字元 (包含標點符號與換行符號) 出現的次數。範例解答將以字典 (Dict) 示範，將出現在字串中的字元作為 key，字元每出現一次就將對應的 value 次數加 1。最後，印出各字元及出現的次數。
#
#【提示】要判斷字典中某個 key 是否存在，可以呼叫 `hashkey(字典, key)`，若 key 存在的話就會回傳 `true`。使用範例請參閱官方文件 [https://docs.julialang.org/en/v1/base/collections/#Base.haskey](https://docs.julialang.org/en/v1/base/collections/#Base.haskey)
#'''
#
## %%
str = "永和有永和路，中和也有永和路，
中和有中和路，永和也有中和路；
中和的中和路有接永和的中和路，
永和的永和路沒接中和的永和路；
永和的中和路有接永和的永和路，
中和的永和路沒接中和的中和路。"

str_dict = Dict()
for si in str
    if haskey(str_dict, si)
        str_dict[si] += 1
    else
        str_dict[si] = 1
    end
end

for si in keys(str_dict)
    println("(key, count) = ($si, $(str_dict[si]))")
end
# %%
