# %%
#'''
# DataFrames.jl 介紹 (二): Joins 與 Split-Apply-Combine Strategy

## Day 018 作業1：The Split-Apply-Combine Strategy

#同 Day 017，請載入 2020/4/2 COVID-19 Daily Report 資料集，計算每個國家/地區的累計確診人數，並列出所有資料筆數。
'''

# %%
using DataFrames, CSV, Statistics

# %%
df = CSV.read("04-02-2020.csv")

# %%
#'''
#計算計算每個國家/地區的累計確診人數
#
#【提示】可使用 groupby 相關的函式
#'''
println("By Country")
#println(by(df, [:Province_State, :Country_Region], :Confirmed=>sum))
println(by(df, [:Country_Region], :Confirmed=>sum))

# %%


# %%
# 顯示所有資料


# %%
'''
## 作業2：請列出美國各區域或事件 (依 Province_State 欄) 的累積確診、死亡、康復人數。
sli = df[:,:Country_Region] .== "US"
df_us = copy(df[sli,:])
println(by(df_us, [:Province_State], :Confirmed=>sum))
println(by(df_us, [:Province_State], :Deaths=>sum))
println(by(df_us, [:Province_State], :Recovered=>sum))


#【提示】使用 Split-Apply-Combine Strategy 時，有幾種不同的函式可以使用，請參照 `DataFrames.jl` 官方文件 [https://juliadata.github.io/DataFrames.jl/stable/lib/functions/#DataFrames.groupby](https://juliadata.github.io/DataFrames.jl/stable/lib/functions/#DataFrames.groupby)
#'''

# %%


# %%
