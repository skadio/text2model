% Parameters
int: horses_available = 60;                 % Total horses available
int: horses_per_medium = 2;                 % Horses needed for one medium cart
int: horses_per_large  = 4;                 % Horses needed for one large cart
int: capacity_medium   = 30;                % Kg of rice carried by one medium cart
int: capacity_large    = 70;                % Kg of rice carried by one large cart
int: min_medium_carts  = 5;                 % Minimum number of medium carts
int: min_large_carts   = 5;                 % Minimum number of large carts
int: medium_to_large_ratio = 3;             % Medium carts must be this times large carts

% Variables
var min_medium_carts..(horses_available div horses_per_medium): medium_carts; % # medium carts used
var min_large_carts..(horses_available div horses_per_large):   large_carts;  % # large carts used
var 0..(capacity_medium*(horses_available div horses_per_medium)
       + capacity_large*(horses_available div horses_per_large)): total_rice; % total kg transported

% Constraints
% Link total_rice to the number of carts chosen
constraint
  total_rice =
    capacity_medium * medium_carts +
    capacity_large  * large_carts;

% Horse availability (resource capacity) constraint
constraint
  horses_per_medium * medium_carts +
  horses_per_large  * large_carts
  <= horses_available;

% Compatibility / ratio constraint: medium carts must be 3 times large carts
constraint
  medium_carts = medium_to_large_ratio * large_carts;

% Objective
solve maximize total_rice;