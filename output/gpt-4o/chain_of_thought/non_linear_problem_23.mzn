% Parameters
int: n;
int: m;
array[1..n, 1..n] of float: currencies;
array[1..n] of string: currencies_s;
float: start;

% Variables
array[1..m] of var 1..n: seq;              % ordered list of currencies in the loop
var float: exchange_product;               % cumulative product of the chosen exchange rates
var float: final_amount;                   % amount after completing the loop
var float: profit;                         % profit with respect to the initial amount

% Constraints
constraint seq[1] = 1;                     % fix starting currency to the first one
constraint all_different(seq);             % each currency appears at most once in the loop

constraint
    exchange_product =
        product(i in 1..m)(
            currencies[seq[i], seq[ if i < m then i + 1 else 1 endif ]]
        );

constraint final_amount = start * exchange_product;
constraint profit = final_amount - start;

% Objective
solve maximize profit;