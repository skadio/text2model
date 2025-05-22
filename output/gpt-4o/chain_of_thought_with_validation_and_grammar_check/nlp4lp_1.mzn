% Parameters
int: M;                                    % Number of goods
int: N;                                    % Number of raw materials

set of int: Goods      = 1..M;
set of int: Materials  = 1..N;

array[Materials] of int: Available;        % Available amount of each material
array[Goods, Materials] of int: Requirements; % Material requirement per unit of each good
array[Goods] of int: Prices;               % Revenue per unit of each good

int: TotalAvailability = sum(i in Materials)(Available[i]);

% Variables
array[Goods] of var 0..TotalAvailability: Produce;   % Units of each good to produce

% Constraints
constraint
    forall(i in Materials)(
        sum(j in Goods)(Requirements[j,i] * Produce[j]) <= Available[i]
    );

% Objective
solve maximize
    sum(j in Goods)(Prices[j] * Produce[j]);