% Parameters
int: horses_available = 60;                 % Total horses available
int: horses_per_medium = 2;                 % Horses needed per medium cart
int: horses_per_large  = 4;                 % Horses needed per large cart
int: capacity_medium = 30;                  % Rice capacity (kg) per medium cart
int: capacity_large  = 70;                  % Rice capacity (kg) per large cart
int: min_medium_carts = 5;                  % Minimum number of medium carts
int: min_large_carts  = 5;                  % Minimum number of large carts
int: medium_to_large_ratio = 3;             % medium carts must be this multiple of large carts

% Variables
var 0..horses_available div horses_per_medium: medium_carts; % bounded by horse limit
var 0..horses_available div horses_per_large:  large_carts;  % bounded by horse limit
var int: total_rice;                                          % Total rice transported (kg)

% Constraints
% Minimum cart requirements (at least the specified minima)
constraint medium_carts >= min_medium_carts;
constraint large_carts  >= min_large_carts;

% Compatibility/ratio requirement: number of medium carts must be a multiple of large carts
constraint medium_carts = medium_to_large_ratio * large_carts;

% Horse availability: total horses used by all carts cannot exceed available horses
constraint horses_per_medium * medium_carts
         + horses_per_large  * large_carts
         <= horses_available;

% Total rice transported: linear linking of decision variables to total_rice
constraint total_rice = capacity_medium * medium_carts
                      + capacity_large  * large_carts;

% Objective
solve maximize total_rice;