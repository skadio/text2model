% Parameters
% Stock limits (units available)
int: stock_apples  = 10;   % Total apples available
int: stock_bananas = 20;   % Total bananas available
int: stock_grapes  = 80;   % Total grapes available

% Banana-haters package composition and profit
int: a_bh = 6;   % Apples per banana-haters package
int: b_bh = 0;   % Bananas per banana-haters package
int: g_bh = 30;  % Grapes per banana-haters package
int: p_bh = 6;   % Profit (euros) per banana-haters package

% Combo package composition and profit
int: a_cb = 5;   % Apples per combo package
int: b_cb = 6;   % Bananas per combo package
int: g_cb = 20;  % Grapes per combo package
int: p_cb = 7;   % Profit (euros) per combo package


% Variables
% Decision variables: how many packages of each type to prepare
var 0..(stock_apples div a_bh): x_banana_haters;  % Number of banana-haters packages
var 0..(stock_bananas div b_cb): x_combo;         % Number of combo packages

% Total profit variable (upper bound based on individual max counts)
var 0..(p_bh * (stock_apples div a_bh) + p_cb * (stock_bananas div b_cb)): total_profit;


% Constraints
% --- Stock availability constraints (do not exceed inventory) ---

% Apples used by both package types must not exceed available apples
constraint
  a_bh * x_banana_haters + a_cb * x_combo <= stock_apples;

% Bananas used by both package types must not exceed available bananas
constraint
  b_bh * x_banana_haters + b_cb * x_combo <= stock_bananas;

% Grapes used by both package types must not exceed available grapes
constraint
  g_bh * x_banana_haters + g_cb * x_combo <= stock_grapes;

% --- Profit accounting constraint (define total_profit consistently) ---
constraint
  total_profit = p_bh * x_banana_haters + p_cb * x_combo;


% Objective
solve maximize total_profit;