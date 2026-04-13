% Parameters
int: avail_paint   = 100;  % available units of paint
int: avail_glitter = 50;   % available units of glitter
int: avail_glue    = 70;   % available units of glue

int: paint_per_large   = 4; % paint units needed per large art piece
int: glitter_per_large = 3; % glitter units needed per large art piece
int: glue_per_large    = 5; % glue units needed per large art piece

int: paint_per_small   = 2; % paint units needed per small art piece
int: glitter_per_small = 1; % glitter units needed per small art piece
int: glue_per_small    = 2; % glue units needed per small art piece

int: min_large = 5; % minimum number of large pieces
int: min_small = 5; % minimum number of small pieces

int: profit_large = 30; % profit per large piece
int: profit_small = 15; % profit per small piece

% Derived upper bounds (to keep decision variables bounded)
int: max_large = min([avail_paint div paint_per_large,
                      avail_glitter div glitter_per_large,
                      avail_glue div glue_per_large]);

int: max_small = min([avail_paint div paint_per_small,
                      avail_glitter div glitter_per_small,
                      avail_glue div glue_per_small]);

% Variables
var min_large..max_large: n_large; % number of large art pieces to make
var min_small..max_small: n_small; % number of small art pieces to make

% Constraints

% Resource capacity constraints (do not exceed available materials)
constraint
  paint_per_large * n_large + paint_per_small * n_small <= avail_paint;

constraint
  glitter_per_large * n_large + glitter_per_small * n_small <= avail_glitter;

constraint
  glue_per_large * n_large + glue_per_small * n_small <= avail_glue;

% Minimum production constraints are already enforced by variable domains:
% n_large in min_large..max_large and n_small in min_small..max_small

% Objective
solve maximize profit_large * n_large + profit_small * n_small;