% Parameters
int: stock_apples = 10;
int: stock_bananas = 20;
int: stock_grapes = 80;

int: a_bh = 6;   % apples in banana-haters package
int: b_bh = 0;   % bananas in banana-haters package
int: g_bh = 30;  % grapes in banana-haters package
int: p_bh = 6;   % profit per banana-haters package

int: a_cb = 5;   % apples in combo package
int: b_cb = 6;   % bananas in combo package
int: g_cb = 20;  % grapes in combo package
int: p_cb = 7;   % profit per combo package

% Variables
var 0..min(stock_apples div a_bh, stock_grapes div g_bh): x_bh; % number of banana-haters packages
var 0..min(min(stock_apples div a_cb, stock_bananas div b_cb), stock_grapes div g_cb): x_cb; % number of combo packages

var 0..(p_bh * (stock_apples div a_bh) + p_cb * (stock_apples div a_cb)): profit;

% Constraints
constraint a_bh * x_bh + a_cb * x_cb <= stock_apples;
constraint b_bh * x_bh + b_cb * x_cb <= stock_bananas;
constraint g_bh * x_bh + g_cb * x_cb <= stock_grapes;

constraint profit = p_bh * x_bh + p_cb * x_cb;

% Objective
solve maximize profit;