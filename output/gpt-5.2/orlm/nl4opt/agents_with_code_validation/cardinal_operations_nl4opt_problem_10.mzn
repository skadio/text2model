% Parameters
int: letters_per_pigeon = 2;          % letters carried by one carrier pigeon
int: treats_per_pigeon  = 3;          % treats required for one carrier pigeon

int: letters_per_owl    = 5;          % letters carried by one owl
int: treats_per_owl     = 5;          % treats required for one owl

int: total_treats       = 1000;       % total treats available
int: min_pigeons        = 20;         % at least this many pigeons must be used
float: max_owl_fraction = 0.40;       % at most this fraction of birds can be owls

% Variables
var 0..total_treats div treats_per_pigeon: pigeons;   % safe upper bound from treats
var 0..total_treats div treats_per_owl: owls;         % safe upper bound from treats
var 0..(letters_per_pigeon * (total_treats div treats_per_pigeon)
      + letters_per_owl * (total_treats div treats_per_owl)): total_letters;

% Constraints

% --- Resource (treat) budget constraint ---
constraint
  treats_per_pigeon * pigeons + treats_per_owl * owls <= total_treats;

% --- Minimum number of carrier pigeons ---
constraint
  pigeons >= min_pigeons;

% --- Owl fraction constraint: owls / (pigeons + owls) <= max_owl_fraction ---
% Rewritten to avoid division:
constraint
  owls <= floor(max_owl_fraction * int2float(pigeons + owls));

% --- Total letters definition ---
constraint
  total_letters = letters_per_pigeon * pigeons + letters_per_owl * owls;

% Objective
solve maximize total_letters;