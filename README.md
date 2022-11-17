# chatbot
人口無能課題

弓削周辺のフェリーの時刻表を教えてくれるチャットボットアシスタント。

辞書：

Google Sheets: 

https://docs.google.com/spreadsheets/d/1wYq4lKjx_REt2sYf9ic6L2bCV_UalAIup2UDFmaHXkA/edit#gid=0


Google Docs: 

https://docs.google.com/document/d/1nfwhjom3lzJMCXvBaAjHNsdfIaSUCcKX7iOnL_Uiqrg/edit


構成図:


https://app.diagrams.net/#Hchinggisod%2Fchatbot%2Fmain%2Fchatbot_plot.drawio

**Response1:** 挨拶                                 **Question1:** ユーザーの＜名前＞ ?      **UserInput1:** ＜名前＞


**Response2:** ＜名前＞に対応                        **Question2:** ＜現在の港＞ ?            **UserInput2:** ＜現在の港＞ 


**Response3:** ＜現在の港＞に対応                     **Question3:** ＜行き先＞?               **UserInput3:** ＜行き先＞


**Response4:** ＜行き先＞に対応                       **Question4:** ＜乗る時間＞？       **UserInput4:** ＜乗る時間＞


**Response5a:** ＜乗る時間＞に合った時間と情報を伝う    **Question5:** ころでよろしい？もう一度確認する？ **UserInput5:** <Yes> Or <No>
  
  
**Response5b:** ＜乗る時間＞は時間外ためもう一度入力お願い
  
  
**Response6:** おしゃべりありがとう
