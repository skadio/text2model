% Parameters
int: eggs_total = 40;
int: bacon_total = 70;

int: eggs_reg = 2;
int: bacon_reg = 3;

int: eggs_spec = 3;
int: bacon_spec = 5;

int: profit_reg = 3;
int: profit_spec = 4;

% Variables
var 0..(eggs_total div eggs_reg): reg;
var 0..(eggs_total div eggs_spec): spec;

% Constraints
constraint eggs_reg * reg + eggs_spec * spec <= eggs_total;
constraint bacon_reg * reg + bacon_spec * spec <= bacon_total;

% Objective
var int: profit = profit_reg * reg + profit_spec * spec;
solve maximize profit;