# %%
#'''
# Julia DataFrames.jl 介紹

# Day 017 作業：載入 COVID-19 資料集

#今天的作業將使用 `DataFrames.jl` 及 `CSV.jl` 套件，來載入美國約翰霍普金斯大學提供的 COVID-19 資料集 (2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins CSSE)。資料集作為教育及研究使用，並且被用來建立視覺化儀表板提供檢視及追蹤 COVID-19 疫情狀況。

#資料集 GitHub: [https://github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19)

#資料集格式為 CSV，整合不同資料來源，主要分為 Daily Report 及時間序列資料。
#
#請自行下載 2020/4/2 的 daily report資料集：[https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/04-02-2020.csv](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/04-02-2020.csv)
#
#Daily Report 主要欄位有：
#
#- Province/State: 省名 (中國)、州名或市名 (美國、加拿大、澳洲)、或是事件名稱 (例如鑽石公主號)...
#- Country/Region: 國名或區域名
#- Last Update: 最後更新日期/時間，格式為 24 小時制的 UTC 時間
#- Confirmed: 確診案例
#- Deaths: 死亡案例
#- Recovered: 康復案例
#- Lat, Long: 經緯度
#- Combined Key: 複合 Key 值
#'''

# %%
using DataFrames, CSV

# %%
df = CSV.read("04-02-2020.csv", delim=",") 

# %%
#'''
#請問此資料集的筆數 (row) 及欄位數 (column) 各是多少？
#'''
row, col = size(df)
println("row=$(row), col=$(col)")

#describe(df)

# %%
#'''
### 作業1：數值 Column 的計算

#請問截至4月2日為止 (UTC 時間)，全球累計的確診、死亡、及㡽復案例數各是多少？

#【提示】可參考 `sum()` 內建函式。
#'''

println("Comfirmed: $(sum(df.Confirmed))")
println("Deaths:    $(sum(df.Deaths))")
println("Recovered: $(sum(df.Recovered))")

# %%


# %%
#'''
#上面解答範例列出確診案例數前 10 名的 Province_State, Country_Region, Confirmed, Deaths, Recovered 等 5 個 column。
#'''

println(df[1:5, [:Province_State, :Country_Region, :Confirmed, :Deaths, :Recovered]])


# %%
#'''
### 作業2：找出特定的 Row

#截至4月2日為止 (UTC 時間)，台灣的確診、死亡、及㡽復案例數為多少？
#
#【提示】使用點運算 `.==` 來比較同一 column 中所有值。
#'''

sli = df[:,:Country_Region] .== "Taiwan*"
df_tw = copy(df[sli,:])
println("Taiwan Comfirmed: $(sum(df_tw.Confirmed))")
println("Taiwan Deaths:    $(sum(df_tw.Deaths))")
println("Taiwan Recovered: $(sum(df_tw.Recovered))")

# %%
