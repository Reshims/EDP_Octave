42;

#=========================[  Callbacks  ]==========================

function on_delete(cbs='', evt=''),
  global CANCEL
  CANCEL = true;

  disp("End of program")
end

function cl_window(cbs='', evt=''),
  global DLG
  global CANCEL
  CANCEL = true;

  close(DLG)
end

function resize(cbs='', evt=''),
  global DLG

  set(DLG, 'units', 'pixels', 'position', [get(DLG, 'position')(1:2) 800 450])
  refresh(DLG)
end

function unanchor(cbs='', evt='', ax, name),
  fg = figure('name', name, 'numbertitle', 'off');
  fax = copyobj(ax, fg);
  hide_axes(fax, 'w')
  set(fax, 'position', [0 0 1 1])
end

function plot_rect(cbs='', evt='', src, dst, sd, v='x', rn=false),
  %inline processing
  [fct, ok] = translate(get(src, 'string'), v);

  if ok,
    if ishandle(sd),
      data = get(sd, 'value');
      if rn,
        data = round(data);
      else,
        data = round(data*100)/100;
      end
    else,
      data = sd;
    end

    x = linspace(0, data, 100);
    plot(dst, x, fct(x))
    set(dst, 'color', [.94 .94 .94], 'xlim', [0 data])
    
    clear x
  end
end

function plot_circ(cbs='', evt='', ax, sd, rn=false),
  z = get(get(ax, 'children')(1), 'YData');
  t = 2*pi*linspace(0, 1, 100);
  x = cos(t);
  y = sin(t);

  if ishandle(sd),
    data = get(sd, 'value');
    if rn,
      data = round(data);
    else,
      data = round(data*100)/100;
    end
  else,
    data = sd;
  end

  figure
  plot3(data.*x, data.*y, z, 'color', 'black', 'linewidth', 2)
  clear x y z t
end

function plot_wave(cbs='', evt='', nul, sep, f, fx, fy, H, L),
  [f, fy, ok, ftype] = check_f_2(nul, sep, f, fx, fy);
  if !ok, return endif
  if ftype == 1, f = @(x, y) f(x) .* fy(y); endif

  H = round(get(H, 'value')*100)/100;
  L = round(get(L, 'value')*100)/100;

  x = linspace(0, H, max(100, 30*H));
  y = linspace(0, L, max(100, 30*L));
  [xx, yy] = meshgrid(x, y);

  figure
  surf(xx, yy, f(xx, yy));
  axis equal
  colormap jet
  shading interp
  
  clear xx yy x y
end
