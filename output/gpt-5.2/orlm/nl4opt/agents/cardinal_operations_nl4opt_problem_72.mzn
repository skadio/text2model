% Parameters
int: powder_available = 100;          % Total available powder units
int: glue_available   = 90;           % Total available glue units
int: mess_limit       = 30;           % Maximum allowed mess units

% Resource usage and production per table setup
int: powder_t1 = 3;                   % Powder used by table 1
int: glue_t1   = 5;                   % Glue used by table 1
int: slime_t1  = 4;                   % Slime produced by table 1
int: mess_t1   = 2;                   % Mess produced by table 1

int: powder_t2 = 8;                   % Powder used by table 2
int: glue_t2   = 6;                   % Glue used by table 2
int: slime_t2  = 5;                   % Slime produced by table 2
int: mess_t2   = 4;                   % Mess produced by table 2

% Variables
var 0..(powder_available div powder_t1): x1;  % Number of table 1 setups
var 0..(powder_available div powder_t2): x2;  % Number of table 2 setups

% Upper bound based on max possible slime if only constrained by powder
var 0..(slime_t1 * (powder_available div powder_t1)
      + slime_t2 * (powder_available div powder_t2)): total_slime; % Total slime produced

% Constraints
% Resource capacity: total powder used cannot exceed available powder
constraint
  powder_t1 * x1 + powder_t2 * x2 <= powder_available;

% Resource capacity: total glue used cannot exceed available glue
constraint
  glue_t1 * x1 + glue_t2 * x2 <= glue_available;

% Mess limit: total mess produced cannot exceed the allowed mess limit
constraint
  mess_t1 * x1 + mess_t2 * x2 <= mess_limit;

% Total slime production definition (linking variable total_slime to decisions)
constraint
  total_slime = slime_t1 * x1 + slime_t2 * x2;

% Objective
solve maximize total_slime;