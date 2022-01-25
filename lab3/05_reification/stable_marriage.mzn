include "globals.mzn";

% Parameters
int: n;
set of int: men = 1..n;
set of int: women = 1..n;
% Lower the rank is, the more preffered is the person
set of int: ranks = 1..n;
% Names, just for fun
array[men] of string: m_names;
array[women] of string: w_names;
% w_ranks[i,j] = how much i'th man is liked by the j'th woman, lowet the better
array[men, women] of ranks: w_ranks;
% m_ranks[i,j] = how much i'th woman is liked by the j'th man, lower the better
array[women, men] of ranks: m_ranks; 

% Variables
% Who is whose wife?
array[1..n] of var 1..n : wives;
% Who is whose husband?
array[1..n] of var 1..n : husbands;

% Predicates
% Just to not care of the way preferences are encoded
predicate prefers_over(array[1..n, 1..n] of var 1..n: ranks, var 1..n: s, var 1..n: p1, var 1..n: p2) =
   ranks[p1, s] < ranks[p2, s];
   
predicate man_prefers_over(var men: m, var women: w1, var women: w2) = 
    prefers_over(m_ranks, m, w1, w2);

predicate woman_prefers_over(var women: w, var men: m1, var men: m2) = 
    prefers_over(w_ranks, w, m1, m2);

% Constraints
% 1) husband of a wife of 'm' is 'm'
constraint forall(i in 1..n)(husbands[wives[i]] = i);
% 2) wife of a husband of 'w' is 'w'
constraint forall(i in 1..n)(wives[husbands[i]] = i);
% 3) if man prefers other woman over his wife, then this other woman prefers her husband over him
constraint forall(i,j in 1..n)(m_ranks[j,i] < m_ranks[wives[i], i] -> w_ranks[i, j] > w_ranks[husbands[j], j]);
% 4) if woman prefers other man over her husband, then this other man prefers his wife over her
constraint forall(i,j in 1..n)(w_ranks[j,i] < w_ranks[husbands[i], i] -> m_ranks[i,j] > m_ranks[wives[j], j]);


% Goal
solve satisfy;

% Output
output [show(m_names[m]) ++ " ♥ " ++ show(w_names[fix(women[m])]) ++ "\n" | m in men];  