% Vaccine production optimization (all data embedded)

% Data (mg and counts)
int: total_mRNA = 20000;

int: mRNA_child = 50;
int: sup_child  = 50;

int: mRNA_adult = 75;
int: sup_adult  = 75;

int: min_children = 50;

% Decision variables
var 0..(total_mRNA div mRNA_child): child;
var 0..(total_mRNA div mRNA_adult): adult;

% Resource constraint: mRNA availability
constraint mRNA_child * child + mRNA_adult * adult <= total_mRNA;

% Policy constraints
constraint child >= min_children;

% At least 70% adult:
% adult / (adult + child) >= 0.7  ->  10*adult >= 7*(adult+child) -> 3*adult >= 7*child
% Also implies if child>0 then adult must be >0; works fine with integer arithmetic.
constraint 3 * adult >= 7 * child;

% Objective: minimize fever suppressant used
var int: total_suppressant = sup_child * child + sup_adult * adult;

solve minimize total_suppressant;

output [
  "children = ", show(child), "\n",
  "adults = ", show(adult), "\n",
  "mRNA_used = ", show(mRNA_child*child + mRNA_adult*adult), " mg\n",
  "suppressant_used = ", show(total_suppressant), " mg\n",
  "adult_share = ",
    if (child + adult) > 0 then
      show( (100 * adult) div (child + adult) )
    else
      "undefined"
    endif,
  "%\n"
];