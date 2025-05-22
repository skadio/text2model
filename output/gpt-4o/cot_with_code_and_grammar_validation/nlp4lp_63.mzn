int: N = 6;
int: M = 8;

array[1..N] of int: Cost = [12000, 16000, 13000, 15000, 9000, 7000];

array[1..N, 1..M] of 0..1: TranslatorLanguagesMatrix =
[|
1,1,0,0,0,0,1,0
|0,1,1,0,1,0,0,0
|1,0,0,1,0,1,0,0
|0,0,1,1,0,0,1,0
|1,0,0,0,1,0,0,1
|0,1,0,0,0,1,0,1
|];

array[1..M] of string: RequiredLanguages =
["FR", "AR", "GE", "RU", "SP", "CH", "IT", "PO"];

array[1..N] of var 0..1: x;

constraint
    forall(j in 1..M)(
        sum(i in 1..N)(TranslatorLanguagesMatrix[i,j] * x[i]) >= 1
    );

solve minimize
    sum(i in 1..N)(Cost[i] * x[i]);