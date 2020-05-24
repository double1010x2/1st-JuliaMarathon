# %%
'''
# Markdown與LaTeX簡介

## Day 002 作業

Sigmoid 和 tanh 是 Machine Learning 中重要且常用的激活函數 (activation function)。

![](https://wikimedia.org/api/rest_v1/media/math/render/svg/36f792c44c0a7069ad01386452569d6e34fe95d7)

Sigmoid 函數的詳細說明，有興趣的話可以參考 [Wikipedia: Sigmoid Function](https://en.wikipedia.org/wiki/Sigmoid_function) 頁面。

那，如果要用 LaTeX 撰寫上面 Sigmoid 公式的話，可以用下列的語法：
```
$$f(x)=\sigma(x)=\frac{1}{1+e^{-x}}$$
```
輸出公式如下：
$$f(x)=\sigma(x)=\frac{1}{1+e^{-x}}$$

下列是幾個重要的 LaTeX 語法簡介：
- `\frac` 分數，並以 `{}{}` 來放分子與分母
- `^` 上標 (superscript)，可用在公式中的次方。若上標的字元超過1的話，也要用 `{}` 包含
- `\sigma` 產生 $\sigma$
'''

# %%
'''
### 題目

tanh (hyperbolic tangent) 是另一個常見的激活函數，其公式如下：

![](https://wikimedia.org/api/rest_v1/media/math/render/svg/84c428bf21e34ccc0be8becf3443b06a4b61f3ee)

請參考練習中 Sigmoid 範例，使用 LaTeX 撰寫 tanh 函數公式。
'''

# %%
