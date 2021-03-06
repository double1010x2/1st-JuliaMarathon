# %%
#'''
## Julia 條件與迴圈
#
### Day 007 作業：使用條件與迴圈找出數值
#
#運用迴圈及條件判斷，找出並印出範圍內 (例如從 1 到 100)，是 3 的倍數，但是無法被 5 整除的數字。
#'''
#
# %%
x = 1 #範圍起始
y = 100 #範圍結束

# %%
# 程式碼
for i in 1:100
    if ((i % 5 != 0) && (i % 3 == 0))
        println("i = $i")
    end
end
# %%
#'''
### Day 007 作業2：請閱讀下列程式碼，並選擇正確的輸出結果
#
#```julia

a=2

while a >= 0
    for b = 0:2
        if (a == b)
            print("1 ")
        else
            print("0 ")
        end
    end
    println()    
    global a -= 1
end
#```

#請問正確的輸出是下列何者？
# Ans: C
#
#A. 1 0 0<br />
#0 1 0<br />
#0 0 1<br />
#
#B. 0 1 0<br />
#1 0 0<br />
#0 0 1<br />
#
#C.  0 0 1<br />
#0 1 0<br />
#1 0 0<br />
#
#D. 1 0 0<br />
#0 0 1<br />
#0 1 0<br />
#'''
#
## %%
# Ans: C
