% Parameters
int: stock_apples  = 10;     % total apples available
int: stock_bananas = 20;     % total bananas available
int: stock_grapes  = 80;     % total grapes available

int: req_apples_banana_haters  = 6;   % apples per banana-haters package
int: req_bananas_banana_haters = 0;   % bananas per banana-haters package
int: req_grapes_banana_haters  = 30;  % grapes per banana-haters package
int: profit_banana_haters      = 6;   % profit per banana-haters package (euros)

int: req_apples_combo  = 5;   % apples per combo package
int: req_bananas_combo = 6;   % bananas per combo package
int: req_grapes_combo  = 20;  % grapes per combo package
int: profit_combo      = 7;   % profit per combo package (euros)

% Upper bounds derived from stock limits (safe integer bounds)
int: ub_banana_haters =
  min(stock_apples div req_apples_banana_haters,
      stock_grapes div req_grapes_banana_haters); % bananas not required

int: ub_combo =
  min(stock_apples div req_apples_combo,
      min(stock_bananas div req_bananas_combo,
          stock_grapes div req_grapes_combo));

% Variables
var 0..ub_banana_haters: x_banana_haters; % number of banana-haters packages
var 0..ub_combo:         x_combo;         % number of combo packages

var 0..stock_apples:  used_apples;  % apples used in total
var 0..stock_bananas: used_bananas; % bananas used in total
var 0..stock_grapes:  used_grapes;  % grapes used in total

var 0..(profit_banana_haters * ub_banana_haters + profit_combo * ub_combo): total_profit;


% Constraints
% Link resource usage to package quantities
constraint
  used_apples =
    req_apples_banana_haters * x_banana_haters +
    req_apples_combo * x_combo;

constraint
  used_bananas =
    req_bananas_banana_haters * x_banana_haters +
    req_bananas_combo * x_combo;

constraint
  used_grapes =
    req_grapes_banana_haters * x_banana_haters +
    req_grapes_combo * x_combo;

% Stock availability limits
constraint used_apples  <= stock_apples;
constraint used_bananas <= stock_bananas;
constraint used_grapes  <= stock_grapes;

% Total profit
constraint
  total_profit =
    profit_banana_haters * x_banana_haters +
    profit_combo * x_combo;


% Objective
solve maximize total_profit;