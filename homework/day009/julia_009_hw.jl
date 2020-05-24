# %%
#'''
# 陣列 (Array)

## Day 009 作業：比較不同的內建排序演算法

#除了範例程式示範的 QuickSort 之外，Julia 也內建支援幾種不同的排序演算法：
#
#- InsertionSort
#- PartialQuickSort(k)
#- MergeSort
#
#1. 請閱讀官方文件及範例 [Sorting-Algorithms](https://docs.julialang.org/en/v1/base/sort/#Sorting-Algorithms-1)
#
#2. 撰寫程式隨機產生 100000 個 200 到 500 之間的數字來建立陣列，執行不同排序方法，來比較不同排序方法的速度。

#**[提示]** 排序執行所需時間可以用巨集 `@time` 或 `@elapsed` 來取得。
#'''

# %%
# 產生 100000 個 200 到 500 之間的數字的陣列
x = rand(200:500, 100000) 

## Insertion Sort
println("[Insertion Sort]")
@time is = sort(x; alg=InsertionSort) 

# %%


## Merge Sort
println("[Merge Sort]")
@time is = sort(x; alg=MergeSort) 

# %%


## Partial Quick Sort
println("[Partial Quick Sort]")
@time is = sort(x; alg=PartialQuickSort(length(x))) 

# %%


## QuickSort
println("[Quick Sort]")
@time is = sort(x; alg=QuickSort) 

# %%
#@elapsed sort(x; alg=QuickSort)

## 請問哪一種排序方法的效能最好？

