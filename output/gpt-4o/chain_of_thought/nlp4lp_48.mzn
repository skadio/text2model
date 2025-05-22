% Parameters
int: A;
set of int: Ads = 1..A;

array[Ads] of int: YoungClicks;      % percentage (0..100) of clicks from 18-25 for each ad
array[Ads] of int: OldClicks;        % percentage (0..100) of clicks from 26+ for each ad
array[Ads] of int: UniqueClicks;     % percentage (0..100) of unique visitors for each ad
array[Ads] of int: Costs;            % cost per click for each ad
array[Ads] of int: MaxClicks;        % maximum clicks purchasable for each ad

int: GoalYoung;          % required total young clicks
int: GoalOld;            % required total old clicks
int: GoalUniqueYoung;    % required total unique young clicks
int: GoalUniqueOld;      % required total unique old clicks


% Variables
array[Ads] of var 0..max(MaxClicks): Clicks;   % clicks to purchase from each ad


% Constraints
constraint
    forall(i in Ads) (
        Clicks[i] <= MaxClicks[i]      % ad-specific upper bound
    );

% Total young clicks (scaled by 100 to keep integrality)
constraint
    sum(i in Ads)(Clicks[i] * YoungClicks[i]) >= GoalYoung * 100;

% Total old clicks (scaled by 100)
constraint
    sum(i in Ads)(Clicks[i] * OldClicks[i])   >= GoalOld * 100;

% Total unique young clicks (scaled by 100*100)
constraint
    sum(i in Ads)(Clicks[i] * YoungClicks[i] * UniqueClicks[i])
        >= GoalUniqueYoung * 100 * 100;

% Total unique old clicks (scaled by 100*100)
constraint
    sum(i in Ads)(Clicks[i] * OldClicks[i] * UniqueClicks[i])
        >= GoalUniqueOld * 100 * 100;


% Objective
solve minimize sum(i in Ads)(Clicks[i] * Costs[i]);