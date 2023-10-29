# HDLBits_training
Just a record about my training process in HDLBits

# My notes
## Full-adder
Full-adder sturcture :  
![](/image_for_notes/Full-adder.svg.png)  
(image is from Wiki)  
Carry-out bit K-map 電路化簡:  
![Full-adder_cout_kmap](/image_for_notes/Full-adder_cout_kmap.jpg)

## Carry-Select Adder
Carry-Select Adder sturcture :  
![](/image_for_notes/carry-select_adder.png)  
(image is from HDLBits)  
以此圖為範例，高位元(31:16)的 Adder16 會有兩個。  
一個 Adder16 Cin 固定輸入 0 (給此 module 編號 A)，  
一個 Adder16 Cin 固定輸入 1 (給此 module 編號 B)。  
此時以低位元(15:0)的 Adder16 輸出的 Cout 當作 MUX 的選擇訊號。  
  
對普通的 Adder32 來說，低位元的 Adder16 之 Cout 會直接連到高位元的 Adder16 之 Cin  
若現在使用 Carry-Select Adder :  
1. 如果低位元的 Adder16 Cout = 0，  
   對普通的 Adder32 來說，原本高位元的 Adder16 本來 Cin 就會是 0  
   我們就選擇 A 的輸出，當作 sum 的高位元
2. 如果低位元的 Adder16 Cout = 1，  
   對普通的 Adder32 來說，原本高位元的 Adder16 本來 Cin 就會是 1  
   我們就選擇 B 的輸出，當作 sum 的高位元

| Structure          | Critical path (delay)| Area          |
| ------------------ |:--------------------:|:-------------:|
| Full Adder         | Adder16 * 2          | **較小**      |
| Carry-Select Adder | **Adder16 + 2to1MUX**| 較大          |

這種作法優劣勢非常明顯，  
我們不需要等待低位元的 Adder16 算出 Cout 再傳給高位元的 Adder16 做計算，  
代價是犧牲了一些面積。  

## Adder & Substractor
Adder & Substractor sturcture :  
![](/image_for_notes/adder_subtractor.png)  
