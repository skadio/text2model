% Parameters
int: total_area = 120;

int: profit_apples  = 2000;
int: profit_pears   = 1800;
int: profit_oranges = 2200;
int: profit_lemons  = 3000;

% Variables
var 0..total_area: apples;
var 0..total_area: pears;
var 0..total_area: oranges;
var 0..total_area: lemons;

array[1..4] of var bool: grow; % 1=apples, 2=pears, 3=oranges, 4=lemons

% Constraints
constraint apples + pears + oranges + lemons <= total_area;

constraint apples >= 2 * pears;
constraint apples >= 3 * lemons;
constraint oranges = 2 * lemons;

% Link grow indicators to whether acreage is positive
constraint apples  <= total_area * bool2int(grow[1]);
constraint pears   <= total_area * bool2int(grow[2]);
constraint oranges <= total_area * bool2int(grow[3]);
constraint lemons  <= total_area * bool2int(grow[4]);

constraint apples  >= bool2int(grow[1]);
constraint pears   >= bool2int(grow[2]);
constraint oranges >= bool2int(grow[3]);
constraint lemons  >= bool2int(grow[4]);

% No more than two fruit types
constraint sum(i in 1..4)(bool2int(grow[i])) <= 2;

% Objective
var int: total_profit =
  profit_apples  * apples +
  profit_pears   * pears +
  profit_oranges * oranges +
  profit_lemons  * lemons;

solve maximize total_profit;