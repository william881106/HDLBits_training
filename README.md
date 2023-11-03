# HDLBits_training
Just a record about my training process in HDLBits

# My notes
## Full-adder
Full-adder sturcture (image is from Wiki) :  
![](/image_for_notes/Full-adder.svg.png)  

Carry-out bit K-map 電路化簡:  
![Full-adder_cout_kmap](/image_for_notes/Full-adder_cout_kmap.jpg)

## Carry-Select Adder
Carry-Select Adder sturcture (image is from HDLBits) :  
![](/image_for_notes/carry-select_adder.png)  

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
Adder & Substractor sturcture (image is from HDLBits) :  
![](/image_for_notes/adder_subtractor.png)  
Binary 補數 :  
```
最高位的 bits 0 代表正數，1 代表負數
Ex.  -7 = ^(0111) + (0001) = (1000) + (0001) = (1001),  也就是 7 的 binary 全數翻轉後再 + 1  
Ex. -28 = ^(00011100) + (8'b1) = (11100011) + (8'b1) = (11100100),  也就是 28 的 binary 全數翻轉後再 + 1
```
補數示意圖 : 
(來源 : https://www.allaboutcircuits.com/technical-articles/twos-complement-representation-theory-and-examples/)
![](/image_for_notes/Complementary.png)  
  
減法器 :  
```
實際上就是"加""負數"  
Ex. 34 - 28 = 34 + (-28) = 6  
            = (00100010) + (11100100)           //根據 Ex. -28 的第三個等號  
            = (00100010) + (11100011) + (8'b1)  //根據 Ex. -28 的第二個等號  
            = (00100010) + ^(00011100) + (8'b1) //根據 Ex. -28 的第一個等號  
            =(100000110) 對於 8-bits 來說 最左邊那個 1 會被捨棄(overflow)，只剩下(00000110)，就會 = 6。
```
根據上面，我們可以知道減法器實際上就是 A - B = A + (^B) + 1，  
所以我們會用 1 來代表要做減法，選擇把 B 做 bit 翻轉，並丟到加法器的 Cin 加起來。
