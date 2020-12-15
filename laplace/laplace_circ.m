function laplace_circ(a, n, f, lb='', vb='', gd=false),
  global CANCEL
  CANCEL = false;

  if ishandle(a), a = round(get(a, 'value')*100)/100; endif
  if ishandle(n), n = round(get(n, 'value')); endif

  if !is_function_handle(f),
    [f, ok] = translate(get(f, 'string'), 't');
    if !ok, return endif
  endif
  if ishandle(gd), gd = get(gd,'value'); endif

  vlb = ishandle(lb);
  vbv = ishandle(vb);
  if vlb, eta = get(lb, 'visible'); set(lb, 'visible', 'on') endif

  r = linspace(0, a, a*50);
  p = linspace(0, 2*pi, 2*pi*50);
  [rr, pp] = meshgrid(r, p);
  xx = rr.*cos(pp);
  yy = rr.*sin(pp);
  z = solve_lc(rr, pp, f, n, a, lb, vlb, vb, vbv);

  if !CANCEL,
    figure

    hold on
    surf(xx, yy, z)
    if gd, plot3(a*cos(p), a*sin(p), f(p), 'linewidth', 2, 'color', 'black') endif
    hold off
    view([60 30])

    axis equal
    colormap jet
    shading interp
  endif

  clear r p rr pp xx yy z
  if vlb, set(lb, 'visible', eta) endif
  CANCEL = true;
end

function [A, B] = coefs_lc(f, n)
  func_a = @(x) f(x).*cos(n*x);
  func_b = @(x) f(x).*sin(n*x);

  A = quadcc(func_a, 0, 2*pi);
  B = quadcc(func_b, 0, 2*pi);
end

function z = solve_lc(r, p, f, n, a, lb, vlb, vb, vbv),
  global CANCEL
  z = zeros(size(r));

  if vbv, set(vb, 'fontsize', 14) endif
  for m = 1:n,
    if vlb, update_loadbar(lb, m/n) endif
    if vbv, set(vb, 'string', sprintf('Calcul des coefficients de projection (%d/%d)', m, n)) endif
    [A, B] = coefs_lc(f, m);
    z += ((r/a).^m) .* (A*cos(m*p) + B*sin(m*p));

    pause(1e-10)
    if CANCEL, break endif
  endfor

  clear r p
  if !CANCEL, z = (z + quadcc(f,  0, 2*pi)/2) / pi;
  else, z = [] endif
end
