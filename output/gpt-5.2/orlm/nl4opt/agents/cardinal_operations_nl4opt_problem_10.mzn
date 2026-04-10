% Parameters
int: letters_per_pigeon = 2;          % letters carried by one carrier pigeon
int: treats_per_pigeon  = 3;          % treats required per carrier pigeon

int: letters_per_owl = 5;             % letters carried by one owl
int: treats_per_owl  = 5;             % treats required per owl

int: total_treats = 1000;             % total treats available
int: min_pigeons  = 20;               % at least this many carrier pigeons must be used

int: max_owl_percent = 40;            % at most 40% of the birds can be owls (percentage)

% Useful derived bound for search (upper bound on total birds by cheapest bird)
int: max_birds = total_treats div min(treats_per_pigeon, treats_per_owl);

% Variables
var min_pigeons..max_birds: pigeons;  % number of carrier pigeons used
var 0..max_birds: owls;               % number of owls used
var 0..(letters_per_pigeon*max_birds + letters_per_owl*max_birds): total_letters; % total letters sent

% Constraints

% Link total_letters to chosen numbers of pigeons and owls
constraint
  total_letters = letters_per_pigeon * pigeons + letters_per_owl * owls;

% Treat budget constraint (cannot exceed available treats)
constraint
  treats_per_pigeon * pigeons + treats_per_owl * owls <= total_treats;

% Owl proportion constraint: owls are at most max_owl_percent of total birds
% Avoid division by cross-multiplying: 100*owls <= max_owl_percent*(pigeons+owls)
constraint
  100 * owls <= max_owl_percent * (pigeons + owls);

% Minimum pigeons requirement (redundant with variable domain but kept for clarity)
constraint
  pigeons >= min_pigeons;

% Objective
solve maximize total_letters;