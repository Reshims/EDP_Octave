42;

function lr_main(L, H, n, f, lb='', vb='', gd=false),
  global CANCEL
  CANCEL = false;

  if ishandle(L), L = round(get(L, 'value')*100)/100; endif
  if ishandle(H), H = round(get(H, 'value')*100)/100; endif
  if ishandle(n), n = round(get(n, 'value')); endif

  if !is_function_handle(f),
    [f, ok] = translate(get(f, 'string'));
    if !ok, return endif
  endif
  if ishandle(gd), gd = get(gd,'value'); endif

  vlb = ishandle(lb);
  vbv = ishandle(vb);
  if vlb, eta = get(lb, 'visible'); set(lb, 'visible', 'on') endif

  x = linspace(0, L, max(100, L*50));
  y = linspace(0, H, max(100, H*50));
  [xx, yy] = meshgrid(x, y);
  z = solve_lr(xx, yy, f, n, H, L, lb, vlb, vb, vbv);

  if !CANCEL,
    figure

    hold on
    surf(xx, yy, z)

    if gd, plot3(x, H*ones(size(x)), f(x), 'linewidth', 2, 'color', 'black') endif
    hold off
    view([-30 10])

    axis equal
    colormap jet
    shading interp
  endif

  clear x y xx yy z
  if vlb, set(lb, 'visible', eta) endif
  CANCEL = true;
end

function z = solve_lr(x, y, f, n, H, L, lb, vlb, vb, vbv),
  global CANCEL
  z = zeros(size(x));

  if vbv, set(vb, 'fontsize', 14) endif
  for m = 1:n,
    if vlb, update_loadbar(lb, m/n) endif
    if vbv, set(vb, 'string', sprintf('Calcul des coefficients de projection (%d/%d)', m, n)) endif
    k = m*pi/L;
    z += 2 * quadcc(@(x) f(x).*sin(k*x), 0, L) .* sin(k*x).*sinh(k*y) / (L*sinh(k*H));

    pause(1e-10)
    if CANCEL, z = []; break endif
  endfor

  clear x y
end
