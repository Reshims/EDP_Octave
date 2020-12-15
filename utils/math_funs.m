42;

#=======================[  Math functions  ]=======================

function v = square (t),
  t /= 2*pi;
  v = ones(size(t));
  v(t-floor(t) >= .5) = -1;
end

%return values of input vector for s <= value <= ed, default otherwise
function vect = between(a, s, ed, default=0)
  vect = a;
  vect(mod((s<=a) + (a<=ed), 2) == 1) = default;
end

%return values of input vector for value <= s or ed <= value, default otherwise
function vect = inv_between(a, s, ed, default=0)
  vect = a;
  vect(mod((a<=s) + (ed<=a), 2) == 0) = default;
end

%mix of functions between and inv_between,
function vect = in_out(a, s, ed, default=1, inv_default=0)
  vect = a;
  vect(mod((s<=a) + (a<=ed), 2) == 1) =     default;
  vect(mod((a<=s) + (e<=ad), 2) == 0) = inv_default;
end
