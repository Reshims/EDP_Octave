42;

%implements the 2 projection matrices onto the base functions for the space dimensions
%it uses n*m = numel(matrix_A) = numel(matrix_B) functions (n for the x axis, m for the y axis)
%
%x, y:               vector  - the 2 component of a mesgrid flattened (use x(:), y(:))
%L, H:               float   - size of the domain [0, L] * [0, H] (x, y)
%matrix_A, matrix_B: matrix  - the matrices of coefs for the (m*n) base functions (shape = [n m])
function [spatial_A, spatial_B] = or_get_at_space(x, y, L, H, matrix_A, matrix_B, lb, vlb, vb, vbv),
	global CANCEL

	[n_max, m_max] = size(matrix_A);
	max_nm = n_max*m_max;
	spatial_A = [];
	spatial_B = [];

	phi_matrix = zeros([max_nm numel(x)]);
	sinx = zeros([n_max numel(x)]);
	siny = zeros([m_max numel(x)]);

	for m = 1:m_max,
		siny(m, :) = sin(pi*m*y/H);
	endfor
	for n = 1:n_max,
		sinx(n, :) = sin(pi*n*x/L);
	endfor

	if vbv, set(vb, 'fontsize', 14) endif
	progress = 0;
	for m = 1:m_max,
		for n = 1:n_max,
			progress += 1;
			if vlb, update_loadbar(lb, progress/max_nm) endif
			if vbv, set(vb, 'string', sprintf('Calcul de la solution spatiale (%d/%d)', progress, max_nm)) endif

			phi_matrix(progress, :) = sinx(n, :) .* siny(m, :);

			pause(1e-10)
			if CANCEL,
				clear phi_matrix sin* x y matrix_*
				return
			endif
		endfor
	endfor

 	spatial_A = matrix_A(:) .* phi_matrix;
 	spatial_B = matrix_B(:) .* phi_matrix;

	clear phi_matrix sin* x y matrix_*
endfunction

%calculate the solution of the wave equation for a specific time 't'
%
%shape:              matrix - shape of the output (size(meshgrid))
%n_max, m_max:       int    - number of base functions to approximate (x * y)
%L, H:               float  - size of the domain [0, L] * [0, H] (x, y)
%matrix_A, matrix_B: matrix - the processed matrices of coefs for the (m*n) base functions (shape = [n*m numel(meshgrid)])
%							  see "get_at_space"
%t:                  float  - the time
function matrix = or_get_at_time(shape, m_max, n_max, L, H, matrix_A, matrix_B, t),
  [M, N] = meshgrid(1:m_max, 1:n_max);
  K = (@(m, n) sqrt((n*pi/L).**2 + (m*pi/H).**2))(M, N)(:);

  matrix = reshape(matrix_A' * cos(K*t) + matrix_B' * sin(K*t), shape);
endfunction

function or_closing(f),
  global CLOSING
  CLOSING = f;
end

function or_anim(x, y, n, m, L, H, matrix_A, matrix_B, sd2, sd3, sd4, sd5),
	sdata = round_100(get(sd2, 'value'));
	edata = round_100(get(sd3, 'value'));
	if sdata == edata,
		or_unique
		return
	endif

	global CANCEL
	global CLOSING
	CANCEL = false;
	CLOSING = 0;

	f = figure();
	set(f, 'deletefcn', @() or_closing(f))

	sol = or_get_at_time(size(x), m, n, L, H, matrix_A, matrix_B, sdata);
	sf = surf(x, y, sol);
	ax = get(sf, 'parent');

	lims = min_max(min(min(sol)), max(max(sol)));
	caxis(lims);
	axis([0, L, 0, H, -2, 2], 'equal')
	colormap('jet')
	shading('interp')

	dt = round(get(sd4, 'value')) * 10^(-round(get(sd5, 'value')));
	t = sdata+dt;
	while t <= edata && CLOSING != f,
		sol = or_get_at_time(size(x), m, n, L, H, matrix_A, matrix_B, t);
		pause(1e-10)
		if CLOSING == f, break endif

		lims = min_max(min(min(sol)), max(max(sol)));
		set(ax, 'clim', lims)
		set(sf, 'ZData', sol, 'CData', sol)
		t += dt;

		pause(1e-10)
		if CANCEL, break endif
	endwhile

	clear sol matrix_* x y sf ax f
	CANCEL = true;
end

function or_unique(x, y, m, n, L, H, matrix_A, matrix_B, sd1),
	figure
	sol = or_get_at_time(size(x), m, n, L, H, matrix_A, matrix_B, round_100(get(sd1, 'value')));
	surf(x, y, sol);

	lims = min_max(min(min(sol)), max(max(sol)));
	set(gca(), 'clim', lims)
	axis([0, L, 0, H, -2, 2], 'equal')
	colormap('jet')
	shading('interp')

	clear sol matrix_* x y sd1
end

function or_control(sd4, sd5, tx4),
  bdata = round(get(sd4, 'value'));
  edata = round(get(sd5, 'value'));

  set(tx4, 'string', sprintf('dt = %de-%d', bdata, edata))
end

function [h, plt] = or_create_handler(x, y, n, m, L, H, matrix_A, matrix_B, s),
	screen_size = get(0, 'screensize');
  screen_center = screen_size(3:4)/2;
  dialog_size = [375 325];
  dialog_pos = [screen_center - dialog_size/2 dialog_size];

	h = dialog('windowstyle', 'normal', 'position', dialog_pos, 'color', [.94 .94 .94]);
	set(h, 'name', ['Panneau de controle pour ' s]);

	[tx1, sd1] = create_slider(h, [1/15 23/26], 't = ', 'Temps pour solution a un temps unique', [0 10], 1.7);
	[tx2, sd2] = create_slider(h, [1/15 20/26], 'start = ', 'Temps de depart pour l''animation', [0 5], 0);
	[tx3, sd3] = create_slider(h, [1/15 17/26], 'end = ', 'Temps de fin pour l''animation', [0 10], 5);

	tx4 = annotation(h, 'textbox', [1/15 25/52 3/40-1/400 1/18-1/225], 'edgecolor', 'none', ...
          'horizontalalignment', 'left', 'string', 'dt = 1e-2', 'fontsize', 16);

	sd4 = uicontrol(h, 'style', 'slider', 'units', 'normalized', 'position', [1/3 14/26-3/325 3/5 1/18], ...
          'min', 1, 'max', 9, 'value', 1, 'tooltipstring', 'Controle la base de dt');
	sd5 = uicontrol(h, 'style', 'slider', 'units', 'normalized', 'position', [1/3 11/26-3/325 3/5 1/18], ...
          'min', 0, 'max', 5, 'value', 2, 'tooltipstring', 'Controle l''exposant de dt');

	pb1 = uicontrol(h, 'style', 'pushbutton', 'string', 'Afficher', 'fontsize', 16, 'units', 'normalized', ...
          'position', [1/15 1/9 11/30 1/9], 'tooltipstring', 'Affiche la solution a un temps unique');
	pb2 = uicontrol(h, 'style', 'pushbutton', 'string', 'Animer', 'fontsize', 16, 'units', 'normalized', ...
          'position', [17/30 1/9 11/30 1/9], 'tooltipstring', 'Anime la solution d''un temps start a un temps end');

	set(sd1, 'position', [1/3 23/26-3/325 3/5 1/18])
	set(sd2, 'position', [1/3 20/26-3/325 3/5 1/18])
	set(sd3, 'position', [1/3 17/26-3/325 3/5 1/18])

	set(sd4, 'callback', @() or_control(sd4, sd5, tx4))
	set(sd5, 'callback', @() or_control(sd4, sd5, tx4))
	addlistener(sd2, 'value', @() update_slider(sd2, sd3, tx3, 'end = '))

	set(pb1, 'callback', @() or_unique(x, y, m, n, L, H, matrix_A, matrix_B, sd1))
	set(pb2, 'callback', @() or_anim(x, y, n, m, L, H, matrix_A, matrix_B, sd2, sd3, sd4, sd5))

	clear tx* sd* pb* x y matrix_* h
end
