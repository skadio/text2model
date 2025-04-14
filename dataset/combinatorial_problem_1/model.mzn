% 
% 3-group split in MiniZinc.
% 
% From 
% http://stackoverflow.com/questions/8762230/what-is-an-algorithm-to-split-a-group-of-items-into-3-separate-groups-fairly
% """
% I have this problem in my textbook: Given a group of n items, each with a distinct value 
% V(i), what is the best way to divide the items into 3 groups so the group with the 
% highest value is minimIzed? Give the value of this largest group.
%
% I know how to do the 2 pile variant of this problem: it just requires running the 
% knapsack algorithm backwards on the problem. However, I am pretty puzzled as how to 
% solve this problem. Could anyone give me any pointers?
% 
% Answer: Pretty much the same thing as the 0-1 knapsack, although 2D
% """

% (Via Mathias Brandewinder, Clear Lines blog
% http://www.clear-lines.com/blog/post/Fair-split-into-3-groups-using-Bumblebee.aspx )

% Note: I assume that "so the group with the highest value is minimIzed" means
% that the _sum_ of the elements in this group is minimized.


% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc/
%

include "globals.mzn"; 

int: n;
array[1..n] of int: a;
% set of int: s = {a[i] | i in 1..n};
int: k;

% decision variables
% array[1..k] of var set of s: x;
array[1..n] of var 1..k: x;
array[1..k] of var 1..2*(sum(a) div k): sums;
var 1..2*(sum(a) div k): max_sum = max(sums);

% solve satisfy;
% solve minimize max_sum;

solve :: int_search(x, most_constrained, indomain_split, complete) minimize max_sum;
% solve :: int_search(x, first_fail, indomain_min, complete) minimize max_sum;

% solve :: seq_search(
%           [
%            int_search(x, first_fail, indomain_split, complete) ,
%            int_search(sums, first_fail, indomain_min, complete),
%           ])
%       minimize max_sum;


% % Set based approach:
% constraint
%     partition_set(x, s)
%     /\
%     forall(i in 1..k) (
%        sums[i] = sum(b in 1..n) ( bool2int( a[b] in x[i])*a[b]) 
%        /\
%        sums[i] > 0
%     )
%     /\
%     increasing(x)
%     /\
%     alldifferent(a)
% ;

constraint
    forall(i in 1..k) (
       sums[i] = sum(j in 1..n) ( bool2int(x[j] = i)*a[j] ) 
    )

    /\ sum(sums) = sum(a)
    % Very few solvers are better with bin_packing()
    % /\ bin_packing(sum(a), x, a) 
    /\ increasing(sums)
;

output [
  "x: " ++ show(x) ++ "\n" ++
  "sums: " ++ show(sums) ++ "\n" ++
  "max_sum: " ++ show(max_sum) ++ "\n"
]
++
[  if i = 1 then "\n" ++ show(j) ++ "(" ++ show(sums[j]) ++ "): " else "" endif ++
      if fix(x[i] = j) then
        show(a[i]) ++ " "
      else 
        ""
      endif
  | j in 1..k, i in 1..n
]
++ ["\n"]
;