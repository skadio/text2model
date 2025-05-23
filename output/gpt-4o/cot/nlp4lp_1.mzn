% Parameters
int: M;                                              % Number of goods
int: N;                                              % Number of raw materials

array[1..N] of int: Available;                       % Availability of each raw material
array[1..N, 1..M] of int: Requirements;              % Raw-material requirements per good
array[1..M] of int: Prices;                          % Revenue per unit of each good

% -------------------------------------------------------------------------

% Derived bounds
array[1..M] of int: MaxProd =                       % Maximum feasible units per good
  [ if exists(i in 1..N where Requirements[i,j] > 0) then
        min([ Available[i] div Requirements[i,j] |
               i in 1..N where Requirements[i,j] > 0 ])
    else
        0
    endif
  | j in 1..M ];

int: U = max(MaxProd);                               % Common upper bound

% -------------------------------------------------------------------------

% Variables
array[1..M] of var 0..U: Produce;                    % Units of each good to produce

% -------------------------------------------------------------------------

% Constraints
constraint
  forall(j in 1..M)(
    Produce[j] <= MaxProd[j]                         % Respect individual upper bounds
  );

constraint
  forall(i in 1..N)(
    sum(j in 1..M)(Requirements[i,j] * Produce[j])   % Raw-material usage
    <= Available[i]                                  % Limited availability
  );

% -------------------------------------------------------------------------

% Objective
solve maximize
  sum(j in 1..M)(Prices[j] * Produce[j]);            % Total revenue