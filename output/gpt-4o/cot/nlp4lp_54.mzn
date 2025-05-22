% Parameters
int: A;
int: Budget;

array[1..A] of int: Costs;            % cost per click of advertisement type a
array[1..A] of int: MaxClicks;        % upper bound on purchasable clicks of type a
array[1..A] of int: YoungClicks;      % percentage (0-100) of clicks coming from ages 18-25 for ad a
array[1..A] of int: OldClicks;        % percentage (0-100) of clicks coming from ages 26+ for ad a
array[1..A] of int: UniqueClicks;     % percentage (0-100) of clicks that are unique for ad a

int: GoalYoung;                       % required 18-25 clicks
int: GoalOld;                         % required 26+  clicks
int: GoalUniqueYoung;                 % required unique 18-25 clicks
int: GoalUniqueOld;                   % required unique 26+  clicks

% Auxiliary bound for decision variables
int: MaxClickBound = max(MaxClicks);

% Variables
array[1..A] of var 0..MaxClickBound: Clicks;   % number of clicks to purchase from ad a

% Constraints
constraint
    forall(a in 1..A)(
        Clicks[a] <= MaxClicks[a]          % respect the individual upper limits
    );

% Budget constraint
constraint
    sum(a in 1..A)( Clicks[a] * Costs[a] ) <= Budget;

% Age-specific click goals  (multiply by 100 to avoid fractions)
constraint
    sum(a in 1..A)( Clicks[a] * YoungClicks[a] ) >= GoalYoung * 100;

constraint
    sum(a in 1..A)( Clicks[a] * OldClicks[a] )   >= GoalOld   * 100;

% Unique click goals per age category (multiply by 10 000 = 100 * 100)
constraint
    sum(a in 1..A)( Clicks[a] * YoungClicks[a] * UniqueClicks[a] ) 
        >= GoalUniqueYoung * 10000;

constraint
    sum(a in 1..A)( Clicks[a] * OldClicks[a]   * UniqueClicks[a] )
        >= GoalUniqueOld   * 10000;

% Objective
solve maximize
    sum(a in 1..A)( Clicks[a] * UniqueClicks[a] );