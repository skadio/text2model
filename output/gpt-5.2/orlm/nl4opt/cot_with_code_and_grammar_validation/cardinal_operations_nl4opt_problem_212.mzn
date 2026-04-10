% Parameters
int: stock_apples = 10;
int: stock_bananas = 20;
int: stock_grapes = 80;

int: reqA_bh = 6;
int: reqB_bh = 0;
int: reqG_bh = 30;
int: profit_bh = 6;

int: reqA_cb = 5;
int: reqB_cb = 6;
int: reqG_cb = 20;
int: profit_cb = 7;

% Variables
var 0..(stock_apples div min(reqA_bh, reqA_cb)): x_bh; % banana-haters packages
var 0..(stock_apples div min(reqA_bh, reqA_cb)): x_cb; % combo packages

var int: total_profit;

% Constraints
constraint reqA_bh * x_bh + reqA_cb * x_cb <= stock_apples;
constraint reqB_bh * x_bh + reqB_cb * x_cb <= stock_bananas;
constraint reqG_bh * x_bh + reqG_cb * x_cb <= stock_grapes;

constraint total_profit = profit_bh * x_bh + profit_cb * x_cb;

% Objective
solve maximize total_profit;