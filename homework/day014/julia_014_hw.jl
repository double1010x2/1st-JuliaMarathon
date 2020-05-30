# %%
#=
# Julia 檔案處理與資料庫連線

## Day 014 作業1：讀取 Nested Dict 內的資料

Day 010 時我們介紹了字典 (Dict)，字典內的資料可以是巢狀 (nested) 的，包含較複雜的資料階層結構。在今天的下載檔 CityCountyData.json 是台灣各縣市鄉鎮區及路名的中英文資料，檔案為 JSON 格式，範例內容如下：

```json
    {
        "CityName": "臺北市",
        "CityEngName": "Taipei City",
        "AreaList": [
            {
                "ZipCode": "100",
                "AreaName": "中正區",
                "AreaEngName": "Zhongzheng Dist."
            },
            ...
    }

作業內容為讀取 JSON 檔案，並列出台北市所有行政區的中英文名稱。範例答案將以 JSON.jl 套件作為示範。

檔案資料來源：[台灣 縣市，鄉鎮，地址 中英文 JSON](https://github.com/donma/TaiwanAddressCityAreaRoadChineseEnglishJSON)
=#

# %%
using JSON

# %%
#=
列出所有台北市行政區的中英文名稱
=#
jf = JSON.parsefile("CityCountyData.json")

for ji in jf
    println("City Name: $(ji["CityName"])")
end
# %%


# %%
#=
## 作業2：將字典資料存為 JSON 檔

作業2請產生字典 (Dict) 資料，並將字典資料存為 JSON 格式。請自行產生字典，也可使用下列的字串資料計算字數 (Day 010 作業程式)。

【提示】可以參考今天範例程式中將陣列資料存為 JSON 格式的部分。
=#

dict1 = Dict("A"=>"a", 
             "B"=>"b")

dict1_json = JSON.json(dict1)

f = open("test_to_json.json", "w")
write(f, dict1_json)
close(f)

#= %%
str = "永和有永和路，中和也有永和路，
中和有中和路，永和也有中和路；
中和的中和路有接永和的中和路，
永和的永和路沒接中和的永和路；
永和的中和路有接永和的永和路，
中和的永和路沒接中和的中和路。

永和有中正路，中和也有中正路；
永和的中正路用景平路接中和的中正路。
永和有中山路，中和也有中山路；
永和的中山路直接接上了中和的中山路。
永和的中正路接上了永和的中山路；
中和的中正路卻不接中和的中山路。

中正橋下來不是中正路，但永和有中正路；
秀朗橋下來不是秀朗路，但永和有秀朗路。
永福橋下來不是永福路，永和沒有永福路；
福和橋下來不是福和路，但福和路接的卻是永福橋。

中和中和路永和永和路
永和中和路中和永和路
中和中山路永和中正路
永和中山路中和中正路"

=# 


