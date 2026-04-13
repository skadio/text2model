% Parameters
int: budget = 20000;
int: cost_mango = 5;
int: cost_guava = 3;
int: profit_mango = 3;
int: profit_guava = 4;
int: mango_min = 100;
int: mango_max = 150;

% Variables
var mango_min..mango_max: mangos;
var 0..(budget div cost_guava): guavas;

% Constraints
constraint cost_mango * mangos + cost_guava * guavas <= budget;
constraint 3 * guavas <= mangos;

% Objective
solve maximize profit_mango * mangos + profit_guava * guavas;