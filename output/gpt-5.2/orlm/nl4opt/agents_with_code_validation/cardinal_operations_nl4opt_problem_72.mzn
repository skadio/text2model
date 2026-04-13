% Parameters
int: powder_available = 100;          % Total available powder
int: glue_available   = 90;           % Total available glue
int: mess_limit       = 30;           % Maximum allowed mess

int: powder_t1 = 3;                   % Powder used per setup of table 1
int: glue_t1   = 5;                   % Glue used per setup of table 1
int: slime_t1  = 4;                   % Slime produced per setup of table 1
int: mess_t1   = 2;                   % Mess produced per setup of table 1

int: powder_t2 = 8;                   % Powder used per setup of table 2
int: glue_t2   = 6;                   % Glue used per setup of table 2
int: slime_t2  = 5;                   % Slime produced per setup of table 2
int: mess_t2   = 4;                   % Mess produced per setup of table 2

% Variables
% Number of times table 1 is set up (bounded by each limiting resource)
var 0..min(powder_available div powder_t1,
           min(glue_available div glue_t1, mess_limit div mess_t1)): x1;

% Number of times table 2 is set up (bounded by each limiting resource)
var 0..min(powder_available div powder_t2,
           min(glue_available div glue_t2, mess_limit div mess_t2)): x2;

% Total slime produced (safe upper bound based on powder-only maxima)
var 0..(slime_t1 * (powder_available div powder_t1)
      + slime_t2 * (powder_available div powder_t2)): total_slime;

% Constraints
% --- Resource capacity constraints (powder and glue) ---
constraint powder_t1 * x1 + powder_t2 * x2 <= powder_available;
constraint glue_t1   * x1 + glue_t2   * x2 <= glue_available;

% --- Mess limit constraint ---
constraint mess_t1 * x1 + mess_t2 * x2 <= mess_limit;

% --- Define total slime produced from chosen table setups ---
constraint total_slime = slime_t1 * x1 + slime_t2 * x2;

% Objective
solve maximize total_slime;