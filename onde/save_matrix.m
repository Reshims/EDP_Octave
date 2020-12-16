42;

%creates a n * m matrix of the coefs of the projections of f and g
%over a domain [0, L] * [0, H] (x, y) with base functions:
%x -> sin(n*pi*x/L)
%y -> sin(m*pi*y/H)
%u is the solution of the wave equation using these parametres (not calculated here)
%
%n_max, m_max:   int      - number of base functions to approximate (x * y)
%f, fy:          function -  u   (x, y, 0), if the function is in the form X(x) * Y(y)
%                                           then use f = X(x), fy = Y(y) and set f_type = 1
%g, gy:          function - du/dt(x, y, 0), if the function is in the form X(x) * Y(y)
%                                           then use g = X(x), gy = Y(y) and set g_type = 1
%L, H:           float    - size of the domain [0, L] * [0, H] (x, y)
%f_type, g_type: int      - type of function, 2 means a 2D function (f(x, y))
%                                             1 means 2 1D functions (X(x), Y(y))
%                                             0 means a null function (f = 0 for all inputs)

function [A_matrix, B_matrix] = or_coefs(L, H, n_max, m_max, f, fy='', g, gy='', f_type=2, g_type=2, lb, vlb, vb, vbv),
  global CANCEL

  %verbose stuff
  progress = 0;
  max_nm = n_max*m_max;
  first = true;

  %outputs
  A_matrix = zeros([n_max, m_max]); %coefs of cosin
  B_matrix = A_matrix;              %coefs of   sin

  %heavy n*m 2D integrals if function != X(x)*Y(y)
  if vbv, set(vb, 'fontsize', 14) endif
  if (f_type == 2) || (g_type == 2),
    warning off
    for n = 1:n_max,
      for m = 1:m_max,
        %ETA
        progress += 1;
        if vlb, update_loadbar(lb, progress/max_nm) endif
        if vbv, set(vb, 'string', sprintf('Calcul des coefficients 2D de projection (%d/%d)', progress, max_nm)) endif

        %current base function
        phi_nm = or_phi(n, m, L, H);

        %calculate projection coef for g and f
        if f_type == 2,
          A_matrix(n, m) = or_coef(f, phi_nm, L, H);
        elseif g_type == 2,
          B_matrix(n, m) = or_coef(g, phi_nm, L, H) / sqrt((n/L)**2 + (m/H)**2);
        endif
        if first, first = false; warning on; endif

        pause(1e-10)
        if CANCEL, return endif
      endfor
    endfor

  %if user used separable functions, calculate base functions for n=1,m=1:m and n=1:n,m=1
  %we can then generate the coef matrix by doing the outer product of the 2 vectors
  %this method change the operations from n*m 2D integrals
  %                                  to   n+m 1D integrals + 1 n*m outer product
  elseif (f_type == 1) || (g_type == 1),
    A_n = zeros([n_max, 1]);
    A_m = zeros([m_max, 1]);
    B_n = A_n;
    B_m = A_m;

    for n = 1:n_max,
      if vlb, update_loadbar(lb, n/n_max) endif
      if vbv, set(vb, 'string', sprintf('Calcul des coefficients de projection en x (%d/%d)', n, n_max)) endif

      if f_type == 1,
        A_n(n) = quadcc(@(x) f(x) .* or_phi_x(n, L)(x), 0, L);
      endif
      if g_type == 1,
        B_n(n) = quadcc(@(x) g(x) .* or_phi_x(n, L)(x), 0, L);
      endif

      pause(1e-10)
      if CANCEL, return endif
    endfor

    for m = 1:m_max,
      if vlb, update_loadbar(lb, m/m_max) endif
      if vbv, set(vb, 'string', sprintf('Calcul des coefficients de projection en y (%d/%d)', m, m_max)) endif

      if f_type == 1,
        A_m(m) = quadcc(@(y) fy(y) .* or_phi_x(m, H)(y), 0, H);
      endif
      if g_type == 1,
        B_m(m) = quadcc(@(y) gy(y) .* or_phi_x(m, H)(y), 0, H);
      endif

      pause(1e-10)
      if CANCEL, return endif
    endfor

    if f_type == 1,
      A_matrix = A_n * A_m';

    elseif g_type == 1,
      B_matrix = B_n * B_m';

      [m, n] = meshgrid(1:m_max, 1:n_max);
      B_matrix ./= (@(m, n) sqrt((n/L)**2 + (m/H)**2))(m, n);

      pause(1e-10)
      if CANCEL, return endif
    endif
  endif

  A_matrix *= 4 / (L*H);
  B_matrix *= 4 / (L*H*pi);
endfunction

%(n, m)th base function for a [0, L] * [0, H] (x, y) domain
%phi(x, y) = X(x) * Y(y) for separation of variables
function func = or_phi(n, m, L, H)
  func = @(x, y) or_phi_x(n, L)(x) .* or_phi_y(m, H)(y);
endfunction

%X(x) in phi(x, y) = X(x) * Y(y)
function func = or_phi_x(n, L)
  func = @(x) sin(n*pi*x/L);
endfunction

%Y(y) in phi(x, y) = X(x) * Y(y)
function func = or_phi_y(m, H)
  func = @(y) sin(m*pi*y/H);
endfunction

%projection of a 2D function onto a 2D base function over a [0, L] * [0, H] (x, y) domain
function scalar = or_coef(f, phi, L, H)
  func = @(x, y) f(x, y) .* phi(x, y);

  scalar = dblquad(func, 0, L, 0, H, :, :, @quadcc);
endfunction
