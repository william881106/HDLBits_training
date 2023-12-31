# HDLBits_training
Just a record about my training process in HDLBits

# Outline
- [My notes](#my-notes)
  * [Replication operator](#replication-operator)
  * [Variable as index](#replication-operator-1)
  * [Connecting Signals to Module Ports](#connecting-signals-to-module-ports)
    + [By position](#by-position)
    + [By name](#by-name)
  * [For-loop in verilog](#for-loop-in-verilog)
  * [generate statement](#generate-statement)
  * [Avoid making latches](#avoid-making-latches)
  * [Full-adder](#full-adder)
  * [Carry-Select Adder](#carry-select-adder)
  * [Adder & Substractor](#adder---substractor)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>



# My notes
## Replication operator  
The replication operator allows repeating a vector and concatenating them together:  
```
{num{vector}}
```
This replicates vector by num times. num must be a constant. Both sets of braces are required.  

Examples:  
```verilog  
assign {5{1'b1}}           // 5'b11111 (or 5'd31 or 5'h1f)
assign {2{a,b,c}}          // The same as {a,b,c,a,b,c}
assign {3'd5, {2{3'd6}}}   // 9'b101_110_110. It's a concatenation of 101 with
                           // the second vector, which is two copies of 3'b110.
```



## Variable as index  
變數可以當作 index 來直接使用:
```verilog
module top_module( 
    input [255:0] in,
    input [7:0] sel,
    output out );
    assign out = in[sel]; //會依照 sel 的數值，取出"in"的第 sel 個 bit
endmodule
```
但是變數無法提供"一個範圍"，具體來說，in[ sel * 4+3 : sel * 4 ] 的寫法編譯會錯誤
```verilog
module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );
    assign out = {in[4*sel+3],in[4*sel+2],in[4*sel+1],in[4*sel]};
endmodule
```



## Connecting Signals to Module Ports
### By position
```verilog
mod_a instance1 ( wa, wb, wc );
```
此方式如同其他多數程式語言 call function 的方式 (C-like syntax)，  
不過如果 module 宣告的 port list 有改變，則程式碼需要跟著改變順序或in/ouput數量。  

### By name
```verilog
mod_a instance2 ( .out(wc), .in1(wa), .in2(wb) );
```
連接時需指定 module 原來的 port 名稱  
好處是這種宣告法不受順序影響，只會依照名子連接  





## For-loop in verilog
```verilog
module top_module( 
    input [254:0] in,
    output reg [7:0] out );
	  
    integer i; // int i; 被宣告在此
    always @(in)begin
        out = 8'd0;  // 如果像下面需要做迴圈"運算"，記得一開始要先初始化數值
        for(i=0; i<255; i++)begin  // for-loop 需要在 always-block 中
            if(in[i]==1'b1)
            	out = out + 1'b1; // 特別注意 for-loop 不能 assign
        end
    end
endmodule
```



## generate statement 
```verilog
genvar i;  // int i; 被宣告在此
generate   // int i; generate statement 開始的宣告
    for(i=0; i<100; i++)begin:BCDblock    // generate 的 for-loop 後面一定要 ":名稱"，名稱隨便取
        if(i == 0)
            bcd_fadd U0(a[3:0], b[3:0], cin, _cout[0], sum[3:0] );
        else
            bcd_fadd U1(a[4*i+3:4*i], b[4*i+3:4*i], _cout[i-1], _cout[i], sum[4*i+3:4*i] );
    end
endgenerate  // int i; generate statement 結束的宣告
assign cout = _cout[99];
```





## Avoid making latches
"語法正確的程式碼" 不等於 "合理的電路" (combinational logic + flip-flops)  
如果出現了"指定case以外的情況"，**Verilog 傾向於保持 output 不變，也就是 latch**  
( Watch out for Warning (10240): ... inferring latch(es)" messages. )  
除非故意使用 latch，否則通常都會造成 bug。  
  
Example (來自 HDLBits 的例子):  

```verilog
module test(
input cpu_overheated,
output reg shut_off_computer
);

always @(*) begin
    if (cpu_overheated)
       shut_off_computer = 1'b1;
end
endmodule 
```
如果我們以這個程式碼下去跑模擬，出來的 block diagram 以及 waveform simulation 會是：
<img src="/image_for_notes/Latch_sim_diagram1.png" alt="Editor" width="500">
![](/image_for_notes/Latch_sim_wave1.png)  
此時發現從 block diagram 發現，output 永遠都是 1，波形根本沒有隨著 input 變動，一直都是鎖定的  
/------------------------------------------------------------------------------------------------------------------------------------------------------------/  
我們對程式碼修改：　　
```verilog
always @(*) begin
    if (cpu_overheated)
        shut_off_computer = 1'b1;
    else
        shut_off_computer = 1'b0;
end
```
<img src="/image_for_notes/Latch_sim_diagram2.png" alt="Editor" width="500">
<img src="/image_for_notes/Latch_sim_wave2.png">

(雖然 cpu_overheated 跟 shut_off_computer 本來就是一樣的值，所以電路不會形成 MUX 只會接在一起)  
這個時候波形跟電路便依照我們想要的狀態去輸出正確的output  
以上例子便可說明【注意所有可能case】的重要性  
另一種 Case statement 寫 default case 的方式：
```verilog
always @(*) begin
    // Another way to write default case
    up = 1'b0; down = 1'b0; left = 1'b0; right = 1'b0;
    case (scancode)
        16'he06b: left = 1'b1;
        16'he072: down = 1'b1;
        16'he074: right = 1'b1;
        16'he075: up = 1'b1;
    endcase
end
```









## Full-adder
Full-adder sturcture (image is from Wiki) :  
![](/image_for_notes/Full-adder.svg.png)  

Carry-out bit K-map 電路化簡:  
<img src="/image_for_notes/Full-adder_cout_kmap.jpg" alt="Editor" width="500">





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

| Structure          | Critical path (delay) | Area          | 
|:------------------:|:---------------------:|:-------------:| 
| Full Adder         | Adder16 * 2           | **較小**      | 
| Carry-Select Adder | **Adder16 + 2to1MUX** | 較大          | 

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
<img src="/image_for_notes/Complementary.png" alt="Editor" width="500">

  
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
