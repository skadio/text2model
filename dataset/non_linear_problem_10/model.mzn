% 
% Decentralization problem in MiniZinc.
% 
% From H. Paul Williams "Model Building in Mathematical Programming", 4th edition
% Decentralization, sections 12.10, 13.10 and 14.10.
%


% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

include "globals.mzn"; 
int: ndepts;  % departments
int: ncities; %  cities, Bristol, Brighton, london
int: ncitiesm1; % cities, Bristol, Brighton

% benefits (£k)
array[1..ndepts,1..ncities] of int: benefit; 

%  communication costs/unit(£)
array[1..ncities,1..ncities] of int: dist;

% quantities of communication (k units)
array[1..ndepts,1..ndepts] of float: comm;


% variables
% = 1 iff dept i in cityj 
array[1..ndepts,1..ncities] of var 0..1: d; 
% = 1 iff dept i in city j and dept k in city l
array[1..ndepts,1..ncities,1..ndepts,1..ncities] of var 0..1: g; 

var float: tcost  = sum(i in 1..ndepts, j in 1..ncitiesm1) (int2float(benefit[i,j])*int2float(d[i,j])) -
                  sum(i in 1..ndepts, j in 1..ncities, k in 1..ndepts, l in 1..ncities where k> i) (
                  comm[i,k]*int2float(dist[j,l])*int2float(g[i,j,k,l])
              );

% solve maximize tcost;
solve :: int_search([d[i,j] | i in 1..ndepts, j in 1..ncities], first_fail, indomain_min, complete) maximize tcost;

constraint
   tcost >= 0.0
   /\

   % each dept i located somewhere  	  	
   forall(i in 1..ndepts) (sum(j in 1..ncities) (d[i,j]) = 1)

   /\
   % at most 3 depts in each city
   forall(j in 1..ncities) (sum(i in 1..ndepts) (d[i,j]) <= 3)
   
   /\ % logical relations
   forall(i in 1..ndepts, j in 1..ncities, k in 1..ndepts, l in 1..ncities where k>i) (
     g[i,j,k,l] - d[i,j] <= 0
     /\
     g[i,j,k,l] - d[k,l] <= 0
     /\
     d[i,j] + d[k,l] - g[i,j,k,l] <= 1
     /\
     g[i,j,k,l] <= 1
   )

   /\
   forall(i in 1..ndepts, j in 1..ncities) (d[i,j] <= 1)
;


output [
  "tcost: ", show(tcost), "\n",
  "d:",
] ++ 
[
  if j = 1 then "\n" else " " endif ++
   show(d[i,j])
  | i in 1..ndepts, j in 1..ncities
]  ++ ["\n"]  % ++ ["\ng:"] ++ 
% [
%   if l = 1 /\ k = 1 then "\n" else "" endif ++
%   if l = 1 then "\n\n" else " " endif ++
%    show(g[i,j,k,l])
%   | i in 1..ndepts, j in 1..ncities, k in 1..ndepts, l in 1..ncities
% ]
++ ["\n"]
;
