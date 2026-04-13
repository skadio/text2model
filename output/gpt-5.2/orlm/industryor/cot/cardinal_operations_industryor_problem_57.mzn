% Parameters (with values embedded)
int: total_area = 120;

int: profit_apples  = 2000;
int: profit_pears   = 1800;
int: profit_oranges = 2200;
int: profit_lemons  = 3000;

% Variables
var 0..total_area: acres_apples;
var 0..total_area: acres_pears;
var 0..total_area: acres_oranges;
var 0..total_area: acres_lemons;

var bool: grow_apples;
var bool: grow_pears;
var bool: grow_oranges;
var bool: grow_lemons;

% Constraints
constraint acres_apples + acres_pears + acres_oranges + acres_lemons <= total_area;

% Linking: if a fruit is not grown then its acres must be 0; if grown then at least 1 acre
constraint acres_apples  <= total_area * bool2int(grow_apples);
constraint acres_pears   <= total_area * bool2int(grow_pears);
constraint acres_oranges <= total_area * bool2int(grow_oranges);
constraint acres_lemons  <= total_area * bool2int(grow_lemons);

constraint acres_apples  >= bool2int(grow_apples);
constraint acres_pears   >= bool2int(grow_pears);
constraint acres_oranges >= bool2int(grow_oranges);
constraint acres_lemons  >= bool2int(grow_lemons);

% At most two fruit types
constraint bool2int(grow_apples) + bool2int(grow_pears) + bool2int(grow_oranges) + bool2int(grow_lemons) <= 2;

% Agronomic constraints
constraint acres_apples >= 2 * acres_pears;
constraint acres_apples >= 3 * acres_lemons;
constraint acres_oranges = 2 * acres_lemons;

% Objective
var int: total_profit =
  profit_apples  * acres_apples +
  profit_pears   * acres_pears +
  profit_oranges * acres_oranges +
  profit_lemons  * acres_lemons;

solve maximize total_profit;