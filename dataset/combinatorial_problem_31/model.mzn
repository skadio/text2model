include "globals.mzn"; 

% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: num_people;  

% Binary compatibility matrix: 
% `compatible[i,j] = 1` if person `i` can donate to person `j`, otherwise `0`.
array[1..num_people, 1..num_people] of int: compatible;

% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% x[p] = recipient of the kidney donated by person `p` (or 0 if not donating)
array[1..num_people] of var 0..num_people: x;

% Binary matrix representation of the exchanges
array[1..num_people, 1..num_people] of var 0..1: y;

% Total number of kidney exchanges performed
var 0..num_people: z = sum([bool2int(x[i] > 0) | i in 1..num_people]);

% -----------------------------
% 3) OBJECTIVE FUNCTION
% -----------------------------

% Maximize the number of successful kidney exchanges
solve :: int_search(
      x ++ [y[p,i] | p,i in 1..num_people], 
      first_fail, 
      indomain_random,  
      complete) 
    maximize z;

% -----------------------------
% 4) CONSTRAINTS
% -----------------------------

% (C1) Ensure a valid kidney exchange cycle
constraint
   alldifferent_except_0(x)  
   /\
   forall(p in 1..num_people) (
     % If this person does not donate a kidney
     (
      x[p] = 0 
      /\ sum([y[p,i] | i in 1..num_people]) = 0 
      /\ sum([y[i,p] | i in 1..num_people]) = 0
     ) 
     \/
     % If this person donates, the recipient must also donate to someone else
     (
       x[p] in {i | i in 1..num_people, compatible[p,i] = 1} % Person `p` must donate to a compatible recipient
       /\ x[x[p]] > 0  % The recipient must also participate in a cycle
       /\ sum([y[p,i] | i in 1..num_people]) = 1 
       /\ sum([y[i,p] | i in 1..num_people]) = 1 
     )
   );

% -----------------------------
% 5) OUTPUT
% -----------------------------

output [
  "Total Exchanges: ", show(z), "\n",
  "Kidney Exchange Assignments:\n"
]
++
[
  if fix(x[i] = 0) then 
     "Person " ++ show(i) ++ ": No donation\n"
  else 
     "Person " ++ show(i) ++ " → Person " ++ show(x[i]) ++ "\n"
  endif  
  | i in 1..num_people
]
++
[ "\nTotal Successful Exchanges: ", show(z), "\n" ];