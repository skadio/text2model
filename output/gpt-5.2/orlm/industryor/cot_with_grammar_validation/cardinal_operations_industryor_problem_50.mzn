% Parameters
int: T = 6; % number of 4-hour time periods / start times
set of int: P = 1..T;

array[P] of int: demand = [10, 15, 25, 20, 18, 12]; % required nurses per period

int: shift_len_periods = 2; % 8 hours = 2 periods of 4 hours
int: reg_cost_per_shift = 10 * 8; % 10 yuan/hour * 8 hours
int: con_cost_per_shift = 15 * 8; % 15 yuan/hour * 8 hours

int: max_staff = sum(demand); % safe upper bound for hires in any batch

% Variables
array[P] of var 0..max_staff: reg; % regular nurses starting at each batch
array[P] of var 0..max_staff: con; % contract nurses starting at each batch

array[P] of var 0..(2*max_staff): total_on_duty; % total nurses on duty each period

var 0..(reg_cost_per_shift*max_staff*T + con_cost_per_shift*max_staff*T): total_cost;

% Constraints
constraint
  forall(p in P) (
    total_on_duty[p] =
      (reg[p] + con[p]) +
      (reg[ if p-1 >= 1 then p-1 else p-1+T endif ] +
       con[ if p-1 >= 1 then p-1 else p-1+T endif ])
  );

constraint
  forall(p in P) (
    total_on_duty[p] >= demand[p]
  );

constraint
  total_cost =
    sum(p in P)(reg_cost_per_shift * reg[p] + con_cost_per_shift * con[p]);

% Objective
solve minimize total_cost;