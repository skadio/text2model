% Parameters (with values embedded)
int: mint_available = 120;
int: active_available = 100;
int: tar_limit = 50;

int: mint_use_demo1 = 10;
int: active_use_demo1 = 20;
int: foam_prod_demo1 = 25;
int: tar_prod_demo1 = 5;

int: mint_use_demo2 = 12;
int: active_use_demo2 = 15;
int: foam_prod_demo2 = 18;
int: tar_prod_demo2 = 3;

% Variables
var 0..mint_available: x1; % number of demonstration 1
var 0..mint_available: x2; % number of demonstration 2
var 0..(foam_prod_demo1*mint_available + foam_prod_demo2*mint_available): total_foam;

% Constraints
constraint mint_use_demo1 * x1 + mint_use_demo2 * x2 <= mint_available;
constraint active_use_demo1 * x1 + active_use_demo2 * x2 <= active_available;
constraint tar_prod_demo1 * x1 + tar_prod_demo2 * x2 <= tar_limit;

constraint total_foam = foam_prod_demo1 * x1 + foam_prod_demo2 * x2;

% Objective
solve maximize total_foam;