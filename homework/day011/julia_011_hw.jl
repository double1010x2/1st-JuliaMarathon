# %%
#'''
# Julia 日期與時間

## Day 011 補充教材：不同語系的月份及星期顯示

#Julia 內建的日期與時間語系是英文，那是要顯示其他語系的話要如何辦到呢？可以設定不同語系的月份和星期名稱，在呼叫時間時指定 `locale` 關鍵字即可。
#'''

# %%
using Dates

# %%
#'''
#Julia 內建的是英文語系。
#'''

# %%
now()

# %%
#'''
#例如：顯示星期幾時，顯示的是英文名稱。
#'''

# %%
dayname(now())

# %%
# 上面的程式等同於指定 english 為語系
dayname(now(); locale="english")

# %%
#'''
#如果我們想要顯示繁體中文的月份和星期，可透過定義**月份全名**、**月份簡稱**、**星期全名**、**星期簡稱**，並指定語系名稱。
#
#下面範例示範了設定**月份全名**、**星期全名**、**星期簡稱** (無月份簡稱)讓 _taiwan_ 語系來使用。
#'''

# %%
taiwan_months = ["一月", "二月", "三月", "四月", "五月", "六月",
                 "七月", "八月", "九月", "十月", "十一月", "十二月"]

taiwan_days = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]

taiwan_days_abbrev = ["週一", "週二", "週三", "週四", "週五", "週六", "週日"]

Dates.LOCALES["taiwan"] = Dates.DateLocale(taiwan_months, [""], taiwan_days, taiwan_days_abbrev);

# %%
#'''
#顯示台灣的星期全名和星期簡稱。
#'''

# %%
dayname(now(); locale="taiwan")

# %%
dayabbr(now(); locale="taiwan")

# %%
#'''
## Day 011 作業：新增另一個語系的月份與星期名稱

#請新增另一個語系的月份及星期，並嘗試印出不同語系的月份及星期簡稱/縮寫。

#下表為法文的月份及星期供參考。
france_months = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet" ,"août", "septembre", "octobre", "novembre", "décembre"]  

france_days = ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"]
france_days_abbrev = [ "lun.", "mar.", "mer.", "jeu.", "ven.", "sam.", "dim."]
#
Dates.LOCALES["france"] = Dates.DateLocale(france_months, [""], france_days, france_days_abbrev);
dayname(now(); locale="france")
dayabbr(now(); locale="france")
