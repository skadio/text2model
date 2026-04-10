% Parameters (provided in .dzn)
int: C;                         % Total capacity of the knapsack
array[int] of int: Value;       % Value of each item (index set comes from data)
array[int] of int: Size;        % Size/weight of each item (same index set as Value)

% Derived index set (avoids needing K to be provided separately)
set of int: ITEMS = index_set(Value);

% Sanity: ensure Value and Size are aligned
constraint index_set(Size) = ITEMS;

% Variables
array[ITEMS] of var 0..1: take; % 1 if item is selected, 0 otherwise

% Objective expression
var int: total_value = sum(i in ITEMS)(Value[i] * take[i]);

% Capacity constraint
constraint sum(i in ITEMS)(Size[i] * take[i]) <= C;

% Objective
solve maximize total_value;