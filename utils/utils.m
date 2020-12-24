42;

#=====================[  Utility functions  ]======================

%return min/max of the largest 0 centered interval between cmin and cmax
%usefull for cmap
function lims = min_max(cmin, cmax),
  if cmax <= 5e-2,
  	ccmin = cmin; ccmax = -cmin;
  elseif cmin >= -5e-2,
  	ccmin = -cmax; ccmax = cmax;
  else
    ccmax = max(cmax, -cmin);
    ccmin = -ccmax;
  endif

  lims = [ccmin, ccmax];
endfunction

function hide_axes(h, c=[.94 .94 .94]),
  set(h, "xtick", [], "xcolor", c, ...
         "ytick", [], "ycolor", c, ...
         "ztick", [], "zcolor", c,
         "color", c)
end

function process_axes(h),
  hide_axes(h)
  colormap(h, jet)
  shading(h, 'interp')
end

function [x, y, z] = load_matrix(p),
  matrix = load(p).matrix;
  x = matrix(:, :, 1);
  y = matrix(:, :, 2);
  z = matrix(:, :, 3);
end

%checks if a given function (string) is correct
%if so, translate it to an anonymous function
%if not, set ok to false
function [f, ok] = translate(s, v='x', narg=1),
  f = ''; ok = false;

  data = parse(s);
  if length(strfind(data, '()')) > 0, %could issue a warning
    disp_err('Fonction sans argument')
    return
  end
  try,
    f = inline(data);
  catch err
    disp_err("Erreur de syntaxe")
    disp(err.message)
    return
  end

  names = argnames(f);
  if length(names) != narg,
    disp_err(sprintf('Nombre d''arguments invalide (%d != %d)', length(names), narg))
    return
  elseif narg == 1 && names{1} != v,
    disp_err(['La fonction doit dependre de ' v ' et pas ' names{1}])
    return
  elseif narg == 2 && (names{1} != 'x' || names{2} != 'y'),
    disp_err(['La fonction doit dependre de x, y et pas ' names{1} ', ' names{2}])
    return
  endif

  source("utils/math_funs.m")

  try,
    warning off
    if narg == 1,
      f(0);
    elseif narg == 2,
      f(0, 0);
    endif
    warning on
  catch err,
    warning on
    if strcmp(err.identifier, "Octave:undefined-function"),
      disp_err('Fonction non reconnue')
      disp(err.message)
      return
    endif
  end

  ok = true;
end

%changes all operations to element-wise ones
%(didn't find how to correcly do it so let's hope noone checks this section of the code)
%(but yeah, Thyrion is an exponant here... hehe)
function s = parse(s),
  s = strrep(s, '**', 'THYRION');

  %s = strrep(s, '+', '.+');
  %s = strrep(s, '-', '.-');
  s = strrep(s, '*', '.*');
  s = strrep(s, '/', './');
  s = strrep(s, '^', '.^');

  s = strrep(s, 'THYRION', '.**');
  s = strrep(s, '..', '.');
end

function [fout, fyout, ok, ftype] = check_f_2(nul, sep, f, fx, fy),
  fout = '';
  fyout = '';
  ftype = -1;

  if get(nul, 'value'),
    fout = @(x, y) zeros(size(x));
    ok = true;
    ftype = 0;
  else,
    if get(sep, 'value'),
      [fout, ok] = translate(get(fx, 'string'), 'x');
      if !ok, return endif
      [fyout, ok] = translate(get(fy, 'string'), 'y');
      if !ok, return endif

      ftype = 1;
    else,
      [fout, ok] = translate(get(f, 'string'), :, 2);
      if !ok, return endif
      ftype = 2;
    endif
  endif
end

function sf = repres_func(f, fy, ftype),
  if ftype == 0,
    sf = '@(x, y) 0';
  elseif ftype == 1,
    sf = func2str(@(x, y) f(x) .* f(y));
  else,
    sf = func2str(f);
  endif
end

function disp_err(msg),
  global ERR_HANDLE
  global CANCEL

  set(ERR_HANDLE, 'string', msg, 'visible', 'on')
  CANCEL = true;
end

%fillable -> text and the inverse
function toggle_edit(varargin),
  for i = 1:numel(varargin),
    h = varargin{i};
    tx = get(h, 'string');
    set(h, 'units', 'pixels')
    pos = get(h, 'position');
    r = pos(1:2); dr = pos(3:4);

    bgc = get(h, 'backgroundcolor');
    fgc = get(h, 'foregroundcolor');

    if strcmp(get(h, 'style'), 'edit'),
      set(h, 'style', 'text', 'backgroundcolor', bgc-.15, ...
        'foregroundcolor', fgc+.3, 'position', [r dr-2], 'string', [' ' tx])
    else,
      set(h, 'style', 'edit', 'backgroundcolor', bgc+.15, ...
        'foregroundcolor', fgc-.3, 'position', [r dr+2], 'string', tx(2:end))
    endif

    set(h, 'units', 'normalized')
    pause(1e-10)
  endfor
end

function toggle_visibilties(varargin),
  for i = 1:numel(varargin),
    toggle_visibilty(varargin{i})
  endfor
end

function toggle_visibilty(h),
  if strcmp(get(h, 'visible'), 'on'),
    set(h, 'visible', 'off')
  else,
    set(h, 'visible', 'on')
  endif
end

function update_loadbar(h, cp),
  bh = get(get(h, "children")(1), "children")(1);

  set(h, 'visible', 'on')
  set(bh, 'position', [0 0 cp 1])
end

function update_slider(lst, sd, tx, s, rn=false),
	v = round_100(get(sd, 'value'), rn);
	data = round_100(get(lst, 'value'), rn);
	set(sd, 'min', data)

	if v < data,
		set(sd, 'value', data)
		set(sd, 'string', sprintf('%s%d', s, data))
	endif
end

function slider_control(src, dst, s, rn=false),
  data = round_100(get(src, 'value'), rn);
  set(dst, 'string', sprintf('%s%d', s, data))
end

function data = round_100(v, rn=false),
  if rn,
    data = round(v);
  else,
    data = round(v*100)/100;
  endif
end

function [tx, sd] = create_slider(h, pos, text, tooltip, lims, value, cb=@slider_control, rn=false),
  tx = annotation(h, 'textbox', [pos 3/40-1/400 1/18-1/225], 'edgecolor', 'none', ...
          'horizontalalignment', 'left', 'string', [text num2str(value)], 'fontsize', 16);

  pos += [3/32 -3/325];
  sd = uicontrol(h, 'style', 'slider', 'units', 'normalized', 'position', [pos 1/4 1/18], ...
          'min', lims(1), 'max', lims(2), 'value', value, 'tooltipstring', tooltip);

  addlistener(sd, 'value', @() cb(sd, tx, text, rn))
end

function [tx, cb] = create_checkbox(h, pos, text, tooltip=''),
  tx = annotation(h, 'textbox', [pos - [-3/80 -1/225 1/400 1/225]], 'edgecolor', 'none', ...
          'horizontalalignment', 'left', 'string', text, 'fontsize', 16);
  cb = uicontrol(h, 'style', 'checkbox', 'units', 'normalized', 'position', [pos(1:2) 1/40 2/45], ...
          'tooltipstring', tooltip);
end

function [tx, ed] = create_edit(h, pos, dim1, dim2, text, value='', tooltip='', visible='on'),
  tx = annotation(h, 'textbox', [pos dim1] - [0 -1/150 -1/400 -1/225], 'edgecolor', 'none', ...
          'horizontalalignment', 'left', 'string', text, 'fontsize', 16, 'visible', visible);

  ed = uicontrol(h, 'style', 'edit', 'horizontalalignment', 'left', 'string', value, ...
          'units', 'normalized', 'position', [pos + [dim1(1)+1/160 0] dim2], ...
          'tooltipstring', tooltip, 'visible', visible);

  addlistener(tx, 'visible', @() set(ed, 'visible', get(tx, 'visible')));
end

function h = create_loadbar(parent, visible='on', cp=0, position=[0 0 0 0], thicc=10, ldc='g', bgc=[.94 .94 .94], bdc='black'),
  h = uipanel(parent, 'visible', visible, 'bordertype', 'none', 'backgroundcolor', bdc, 'position', position);
  set(h, 'units', 'pixels')
  dims = get(h, 'position')(3:4) + 2;
  set(h, 'units', 'normalized')

  bgbar = uipanel(h, 'bordertype', 'none', 'backgroundcolor', bgc, 'units', 'pixels', 'position', [thicc thicc (dims-2*thicc)]);
  set(bgbar, 'units', 'normalized')

  uipanel(bgbar, 'bordertype', 'none', 'backgroundcolor', ldc, 'position', [0 0 cp 1]);
end

function h = create_verbose(parent, lb, position, fs=16, fgc=[0 0 0], bgc=[.94 .94 .94]),
  h = annotation(parent, 'textbox', position, 'visible', get(lb, 'visible'), ...
        'horizontalalignment', 'center', 'color', fgc, 'backgroundcolor', bgc, ...
        'fontsize', fs, 'edgecolor', 'none', 'fitboxtotext', 'off');

  addlistener(lb, 'visible', @() set(h, 'visible', get(lb, 'visible')))
end
