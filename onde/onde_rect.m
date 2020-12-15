source("onde/save_matrix.m")
source("onde/utils.m")

function onde_rect(L, H, n, m, res, ...      %plot data
                   fnl, fsp, f, fx, fy, ...  %f(x, y)
                   gnl, gsp, g, gx, gy, ...  %g(x, y)
                   lb, vb),                  %verbose

  global CANCEL
  CANCEL = false;

  %check params
  if ishandle(n), n = round(get(n, 'value')); endif
  if ishandle(m), m = round(get(m, 'value')); endif
  if n*m > 7000,
    errordlg({'Le nombre de fonction propres (m*n)', 'ne peut depasser 7000'}, 'Erreur')
    CANCEL = true;
    return
  endif


  if ishandle(L), L = round(get(L, 'value')*100)/100; endif
  if ishandle(H), H = round(get(H, 'value')*100)/100; endif
  if ishandle(res), res = round(get(res, 'value')); endif

  %check functions
  if !is_function_handle(f),
   [f, fy, ok, ftype] = check_f_2(fnl, fsp, f, fx, fy);
   if !ok, return endif
  endif
  if !is_function_handle(g),
   [g, gy, ok, gtype] = check_f_2(gnl, gsp, g, gx, gy);
   if !ok, return endif
  endif

  %check verbose
  vlb = ishandle(lb);
  vbv = ishandle(vb);
  if vlb, eta = get(lb, 'visible'); set(lb, 'visible', 'on') endif

  [matrix_A, matrix_B] = save_matrix(L, H, n, m, f, fy, g, gy, ftype, gtype, lb, vlb, vb, vbv);

  if vlb, set(lb, 'visible', eta) endif
  if CANCEL,
    clear matrix_A matrix_B
    return
  endif

  x = linspace(0, H, res*H);
  y = linspace(0, L, res*L);
  [xx, yy] = meshgrid(x, y);

  if vlb, eta = get(lb, 'visible'); set(lb, 'visible', 'on') endif
  [spatial_A, spatial_B] = or_get_at_space(xx(:), yy(:), L, H, matrix_A, matrix_B, lb, vlb, vb, vbv);

  clear matrix_A matrix_B x y

  if vlb, set(lb, 'visible', eta) endif
  if CANCEL,
    clear spatial_* xx yy
    return
  endif

  sf = ['f(x, y) =' repres_func(f, fy, ftype)(8:end)];
  sg = ['g(x, y) =' repres_func(g, gy, gtype)(8:end)];

  or_create_handler(xx, yy, n, m, L, H, spatial_A, spatial_B, [sf, ', ', sg]);

  clear xx yy spatial_*
  CANCEL = true;
end
