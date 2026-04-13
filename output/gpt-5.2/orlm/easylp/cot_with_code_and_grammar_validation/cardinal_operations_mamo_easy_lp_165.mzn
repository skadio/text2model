% Parameters
int: cost_adv = 3;
int: cost_pro = 2;
int: cost_sal = 1;

int: min_adv_plus_pro = 10000;
int: max_2adv_plus_sal = 50000;
int: min_sal_minus_pro = 2000;

int: max_adv = 30000;
int: max_pro = 20000;
int: max_sal = 25000;

% Variables
var 0..max_adv: Advertising;
var 0..max_pro: Promotion;
var 0..max_sal: Sales;

var int: TotalCost;

% Constraints
constraint Advertising + Promotion >= min_adv_plus_pro;
constraint 2 * Advertising + Sales <= max_2adv_plus_sal;
constraint Sales - Promotion >= min_sal_minus_pro;

constraint TotalCost = cost_adv * Advertising + cost_pro * Promotion + cost_sal * Sales;

% Objective
solve minimize TotalCost;