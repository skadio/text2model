% Parameters
% Resource availability (all data embedded as per instructions)
int: paint_available   = 100;
int: glitter_available = 50;
int: glue_available    = 70;

% Resource usage per unit produced
int: paint_per_large   = 4;
int: glitter_per_large = 3;
int: glue_per_large    = 5;

int: paint_per_small   = 2;
int: glitter_per_small = 1;
int: glue_per_small    = 2;

% Minimum production requirements
int: min_large = 5;
int: min_small = 5;

% Profit per unit
int: profit_large = 30;
int: profit_small = 15;

% Useful upper bounds from resource limits (for bounded variable domains)
int: max_large = min([paint_available div paint_per_large,
                      glitter_available div glitter_per_large,
                      glue_available div glue_per_large]);
int: max_small = min([paint_available div paint_per_small,
                      glitter_available div glitter_per_small,
                      glue_available div glue_per_small]);

% Variables
var min_large..max_large: large_units; % number of large art pieces to produce
var min_small..max_small: small_units; % number of small art pieces to produce

var 0..(profit_large*max_large + profit_small*max_small): total_profit; % total profit


% Constraints

% Resource capacity constraints (do not exceed available resources)
constraint
  paint_per_large * large_units + paint_per_small * small_units
  <= paint_available;

constraint
  glitter_per_large * large_units + glitter_per_small * small_units
  <= glitter_available;

constraint
  glue_per_large * large_units + glue_per_small * small_units
  <= glue_available;

% Profit calculation constraint (link total_profit to production decisions)
constraint
  total_profit = profit_large * large_units + profit_small * small_units;


% Objective
solve maximize total_profit;