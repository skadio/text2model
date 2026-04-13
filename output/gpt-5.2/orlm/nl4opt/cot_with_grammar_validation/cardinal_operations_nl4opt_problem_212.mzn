% Parameters
int: apples_stock = 10;
int: bananas_stock = 20;
int: grapes_stock = 80;

int: apples_banana_haters = 6;
int: bananas_banana_haters = 0;
int: grapes_banana_haters = 30;
int: profit_banana_haters = 6;

int: apples_combo = 5;
int: bananas_combo = 6;
int: grapes_combo = 20;
int: profit_combo = 7;

% Variables
var 0..apples_stock: x_banana_haters;
var 0..apples_stock: x_combo;

var 0..apples_stock: used_apples;
var 0..bananas_stock: used_bananas;
var 0..grapes_stock: used_grapes;

var 0..(profit_banana_haters * apples_stock + profit_combo * apples_stock): total_profit;

% Constraints
constraint used_apples = apples_banana_haters * x_banana_haters + apples_combo * x_combo;
constraint used_bananas = bananas_banana_haters * x_banana_haters + bananas_combo * x_combo;
constraint used_grapes = grapes_banana_haters * x_banana_haters + grapes_combo * x_combo;

constraint used_apples <= apples_stock;
constraint used_bananas <= bananas_stock;
constraint used_grapes <= grapes_stock;

constraint total_profit = profit_banana_haters * x_banana_haters + profit_combo * x_combo;

% Objective
solve maximize total_profit;