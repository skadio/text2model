% Parameters
int: TotalAircraft;
int: TotalRoutes;

array[1..TotalAircraft] of int: Availability;          % maximum number of routes each aircraft can fly
array[1..TotalRoutes]  of int: Demand;                 % passengers to be served on each route

array[1..TotalAircraft, 1..TotalRoutes] of int: Capacity; % passenger capacity if aircraft a flies route r
array[1..TotalAircraft, 1..TotalRoutes] of int: Costs;    % cost of assigning aircraft a to route r

% Decision variables
array[1..TotalAircraft, 1..TotalRoutes] of var 0..1: y;   % 1 if aircraft a is assigned to route r

% Constraints
constraint
  forall(a in 1..TotalAircraft) (
    sum(r in 1..TotalRoutes)( y[a,r] ) <= Availability[a]   % aircraft availability
  );

constraint
  forall(r in 1..TotalRoutes) (
    sum(a in 1..TotalAircraft)( Capacity[a,r] * y[a,r] ) >= Demand[r]  % satisfy route demand
  );

% Objective
solve minimize
  sum(a in 1..TotalAircraft, r in 1..TotalRoutes)( Costs[a,r] * y[a,r] );