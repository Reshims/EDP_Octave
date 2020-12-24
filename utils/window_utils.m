global PATHS
for i = 1:numel(PATHS),
  source(PATHS{i})
endfor

#========================[  Main program  ]========================

function appli_gui(pname),
  global DLG            %gui handler
  global ERR_HANDLE     %annotation - see 'disp_err'
  global CANCEL         %stop computation if changing frame
  global DRAWING        %don't change frame if currently drawing one
  CANCEL = false;
  DRAWING = false;

  screen_size = get(0, 'screensize');
  screen_center = screen_size(3:4)/2;
  dialog_size = [800 450];
  dialog_pos = [screen_center - dialog_size/2 dialog_size];

  DLG = figure('name', pname, 'windowstyle', 'normal', "position", dialog_pos, ...
              'menubar', 'none', 'numbertitle', 'off', "color", [.94 .94 .94], ...
              'deletefcn', @on_delete);

  ERR_HANDLE = uicontrol(DLG, 'style', 'text', 'visible', 'off', 'units', 'normalized', ...
        'position', [0 0 0 0], 'horizontalalignment', 'center', 'foregroundcolor', 'r', ...
        'backgroundcolor', [1 .8 .8], 'handlevisibility', 'off');
  addlistener(ERR_HANDLE, 'visible', @() {pause(3); set(ERR_HANDLE, 'visible', 'off')})

  add_menu
  main_menu
end

#===========================[  Header  ]===========================

function add_menu,
  global DLG

  main_menu = uimenu(DLG, 'label', '&Navigation',            'accelerator', 'n', 'handlevisibility', 'off');
  uimenu(main_menu,       'label', 'Menu &principal',        'accelerator', 'p', 'callback', @main_menu);
  uimenu(main_menu,       'label', '&Taille originelle',     'accelerator', 't', 'callback', @resize);
  uimenu(main_menu,       'label', '&Quitter',               'accelerator', 'q', 'callback', @cl_window);

  laplace   = uimenu(DLG, 'label', '&Laplace',               'accelerator', 'l', 'handlevisibility', 'off');
  uimenu(laplace,         'label', 'Choix du &domaine',      'accelerator', 'd', 'callback', @laplace_dom);
  uimenu(laplace,         'label', 'Domaine &rectangulaire', 'accelerator', 'r', 'callback', @laplace_rect);
  uimenu(laplace,         'label', 'Domaine &circulaire',    'accelerator', 'c', 'callback', @laplace_circle);

  onde      = uimenu(DLG, 'label', '&Onde',                  'accelerator', 'o', 'handlevisibility', 'off');
  uimenu(onde,            'label', '&Onde',                  'accelerator', 'o', 'callback', @wave);

  refresh(DLG)
end

#===========================[  Frames  ]===========================

function main_menu(cbs='', evt=''),
  global FLP
  global DLG
  global CANCEL
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  set(DLG, 'color', [.94 .94 .94])

  %plot previews
  gh1 = axes(DLG);
  gh2 = axes(DLG);
  [x, y, z] = load_matrix([FLP 'examples/laplace_1.example']);
  surf(gh1, x, y, z); %laplace
  [x, y, z] = load_matrix([FLP 'examples/onde_rect_1.example']);
  surf(gh2, x, y, z); %onde
  process_axes(gh1); set(gh1, "view", [60 30])
  process_axes(gh2); set(gh2, "zlim", [-1 1])

  set(gh1, 'position', [1/32 1/18 7/16 11/18])
  set(gh2, 'position', [17/32 1/18 7/16 11/18])

  %unanchor preview
  uh1 = uicontrol(DLG, 'units', 'normalized', 'position', [1/32 1/18 .09 .05], 'style', 'pushbutton', ...
        'string', 'Decrocher', 'callback', {@unanchor, gh1, "Example de Laplace"}, ...
        'tooltipstring', 'Ouvrir l''example en grand');
  uh2 = uicontrol(DLG, 'units', 'normalized', 'position', [17/32 1/18 .09 .05], 'style', 'pushbutton', ...
        'string', 'Decrocher', 'callback', {@unanchor, gh2, "Example d\47Onde"}, ...
        'tooltipstring', 'Ouvrir l''example en grand');


  %navigation buttons
  b1 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Laplace', 'units', 'normalized', ...
         'fontsize', 20, 'position', [1/8 2/3 1/4 1/6], 'callback', @laplace_dom);
  b2 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Onde', 'units', 'normalized', ...
         'fontsize', 20, 'position', [5/8 2/3 1/4 1/6], 'callback', @wave);

  clear x y z gh* uh* b*
  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end

function laplace_dom(cbs='', evt=''),
  global FLP
  global DLG
  global CANCEL
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  set(DLG, 'color', [.94 .94 .94])

  %plot previews
  gh1 = axes(DLG);
  gh2 = axes(DLG);
  [x, y, z] = load_matrix([FLP 'examples/laplace_2.example']);
  surf(gh1, x, y, z); %rect
  [x, y, z] = load_matrix([FLP 'examples/laplace_1.example']);
  surf(gh2, x, y, z); %circ
  process_axes(gh1); set(gh1, "view", [-30 10])
  process_axes(gh2); set(gh2, "view", [60 30])

  set(gh1, 'position', [1/32 1/18 7/16 11/18])
  set(gh2, 'position', [17/32 1/18 7/16 11/18])

  %unanchor preview
  uh1 = uicontrol(DLG, 'units', 'normalized', 'position', [1/32 1/18 .09 .05], 'style', 'pushbutton', ...
        'string', 'Decrocher', 'callback', {@unanchor, gh1, "Example de Domaine rectangulaire"}, ...
        'tooltipstring', 'Ouvrir l''example en grand');
  uh2 = uicontrol(DLG, 'units', 'normalized', 'position', [17/32 1/18 .09 .05], 'style', 'pushbutton', ...
        'string', 'Decrocher', 'callback', {@unanchor, gh2, "Example de Domaine circulaire"}, ...
        'tooltipstring', 'Ouvrir l''example en grand');


  %navigation buttons
  b1 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Domaine rectangulaire', 'units', 'normalized', ...
        'fontsize', 13, 'position', [1/8 2/3 1/4 1/6], 'callback', @laplace_rect);
  b2 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Domaine circulaire', 'units', 'normalized', ...
        'fontsize', 13, 'position', [5/8 2/3 1/4 1/6], 'callback', @laplace_circle);

  clear x y z gh* uh* b*
  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end

function laplace_rect(cbs='', evt=''),
  global DLG
  global CANCEL
  global ERR_HANDLE
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  set(DLG, 'color', [.94 .94 .94])
  set(ERR_HANDLE, 'position', [3/32 7/18 5/16 1/18])

  %sliders
  [tx1, sd1] = create_slider(DLG, [1/16 8/9], 'n = ', 'Nombre de fonctions propres', [30, 100], 50, :, true);
  [tx2, sd2] = create_slider(DLG, [1/16 7/9], 'L = ', 'Taille du domaine en x', [1, 5], 4);
  [tx3, sd3] = create_slider(DLG, [1/16 6/9], 'H = ', 'Taille du domaine en y', [1, 5], 4);

  %checkbox for plotting u(x, H)
  [gtx, gcb] = create_checkbox(DLG, [1/16 5/9 3/40 1/18], 'dessiner u(x, H) en evidence', 'Supperpose la condition limite avec la solution');


  %plot of u(x, y=H)
  preview = axes(DLG, 'color', [.94 .94 .94], 'box', 'on');
  set(preview, 'position', [9/16 1/18 3/8 2/3])

  [ftx, fed] = create_edit(DLG, [9/16 8/9], [3/40 1/18], [47/160 1/18], 'u(x, H) = ', 'sin(pi*x/4)*square(2*pi*x)', 'Contrainte non-homogene de u');
  cpb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Afficher u(x, H)', 'fontsize', 14, ...
          'units', 'normalized', 'position', [9/16 7/9 11/64 1/12], 'callback', {@plot_rect, fed, preview, sd2}, ...
          'tooltipstring', 'Previsualise u(x, y=H)', 'createfcn', {@plot_rect, fed, preview, sd2});

  %start the simulation
  spb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Start', 'fontsize', 16, 'units', 'normalized', ...
          'position', [1/8 1/9 1/4 1/9], 'tooltipstring', 'Lance la simulation');
  %loading bar for ETA of simulation
  slb = create_loadbar(DLG, false, 0, [1/16 5/18 3/8 1/18], 2);
  svb = create_verbose(DLG, slb, [3/32 6/18 5/16 1/18], 20);

  set(gcb, 'value', 0)
  set(spb, 'callback', @() lr_main(sd2, sd3, sd1, fed, slb, svb, gcb))

  clear tx* sd* *tx gcb fed *pb slb svb
  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end

function laplace_circle(cbs='', evt=''),
  global DLG
  global CANCEL
  global ERR_HANDLE
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  set(DLG, 'color', [.94 .94 .94])
  set(ERR_HANDLE, 'position', [3/32 7/18 5/16 1/18])

  %sliders
  [tx1, sd1] = create_slider(DLG, [1/16 8/9], 'n = ', 'Nombre de fonctions propres', [30, 100], 30, :, true);
  [tx2, sd2] = create_slider(DLG, [1/16 7/9], 'R = ', 'Taille du domaine en r', [1, 3], 1);

  %checkbox for plotting u(R, t)
  [gtx, gcb] = create_checkbox(DLG, [1/16 6/9 3/40 1/18], 'dessiner u(x, H) en evidence', 'Supperpose la condition limite avec la solution');


  %plot of u(r=R, t)
  preview = axes(DLG, 'color', [.94 .94 .94], 'box', 'on');
  set(preview, 'position', [9/16 1/18 3/8 2/3])

  [ftx, fed] = create_edit(DLG, [9/16 8/9], [3/40 1/18], [47/160 1/18], 'u(R, t) = ', 'square(5*t)/2', 'Contrainte non-homogene de u');
  cpb1 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Afficher u(R, t)', 'fontsize', 14, ...
          'units', 'normalized', 'position', [9/16 7/9 11/64 1/12], 'callback', {@plot_rect, fed, preview, 2*pi, 't'}, ...
          'tooltipstring', 'Previsualiser u(r=R, t) en 2D', 'createfcn', {@plot_rect, fed, preview, 2*pi, 't'});
  cpb2 = uicontrol(DLG, 'style', 'pushbutton', 'string', 'En 3D', 'fontsize', 14, ...
          'units', 'normalized', 'position', [27/32 7/9 3/32 1/12], 'callback', {@plot_circ, preview, sd2}, ...
          'tooltipstring', 'Previsualise u(r=R, t) en 3D');

  %start the simulation
  spb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Start', 'fontsize', 16, 'units', 'normalized', ...
          'position', [1/8 1/9 1/4 1/9], 'tooltipstring', 'Lance la simulation');
  %loading bar for ETA of simulation
  slb = create_loadbar(DLG, false, 0, [1/16 5/18 3/8 1/18], 2);
  svb = create_verbose(DLG, slb, [3/32 6/18 5/16 1/18], 20);

  set(gcb, 'value', 0)
  set(spb, 'callback', @() lc_main(sd2, sd1, fed, slb, svb, gcb));

  clear tx* sd* *tx gcb fed cpb* spb slb svb
  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end

function wave(cbs='', evt=''),
  global DLG
  global CANCEL
  global ERR_HANDLE
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  set(DLG, 'color', [.94 .94 .94])
  set(ERR_HANDLE, 'position', [3/32 7/18 5/16 1/18])

  %sliders
  [tx1, sd1] = create_slider(DLG, [1/16 8/9], 'n = ', 'Nombre de fonctions propres en x pour f et g', [30 100], 30, :, true);
  [tx2, sd2] = create_slider(DLG, [1/16 7.25/9], 'm = ', 'Nombre de fonctions propres en y pour f et g', [30 100], 30, :, true);
  [tx3, sd3] = create_slider(DLG, [1/16 6.5/9], 'L = ', 'Taille du domaine en x', [1 5], 4);
  [tx4, sd4] = create_slider(DLG, [1/16 5.75/9], 'H = ', 'Taille du domaine en y', [1 5], 4);
  [tx5, sd5] = create_slider(DLG, [1/16 5/9], 'Res = ', 'Resolution du domaine', [30 50], 30, :, true);

  %checkboxes
  [tx6, cb1] = create_checkbox(DLG, [1/2 8/9 3/40 1/18], 'f nulle', 'Pose f(x, y) = 0'); set(tx6, 'position', get(tx6, 'position') + [0 1/225 0 0])
  [tx7, cb2] = create_checkbox(DLG, [3/4 8/9 3/40 1/18], 'Separer f', 'Separe f(x, y) en fx(x)*fy(y)');
  [tx8, cb3] = create_checkbox(DLG, [1/2 4/9 3/40 1/18], 'g nulle', 'Pose g(x, y) = 0');
  [tx9, cb4] = create_checkbox(DLG, [3/4 4/9 3/40 1/18], 'Separer g', 'Separe g(x, y) en gx(x)*gy(y)');

  %f and fx/fy
  [ftx1, fed1] = create_edit(DLG, [1/2 58/72], [3/40 1/18], [47/160 1/18], 'f(x, y) = ', 'sin(2*pi*x*y/4)', 'Condition non-homogene de u en t = 0', false);
  [ftx2, fed2] = create_edit(DLG, [1/2 58/72], [3/40 1/18], [47/160 1/18], 'fx(x)   = ', 'sin(pi*between(x, 0, 1))', 'Composante en x de f(x,y) = fx(x)*fy(y)');
  [ftx3, fed3] = create_edit(DLG, [1/2 51/72], [3/40 1/18], [47/160 1/18], 'fy(y)   = ', 'sin(pi*between(y - 1.5, 0, 1))', 'Composante en y de f(x,y) = fx(x)*fy(y)');
  fpb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Afficher f(x, y)', 'fontsize', 16, 'units', 'normalized', ...
          'position', [9/16 5/9 1/4 1/9], 'tooltipstring', 'Affiche f(x, y) en 3D');

  %g and gx/gy
  [gtx1, ged1] = create_edit(DLG, [1/2 26/72], [3/40 1/18], [47/160 1/18], 'g(x, y) = ', 'sin(pi*(1 - x*y)/4)', 'Condition non-homogene de du/dt en t = 0');
  [gtx2, ged2] = create_edit(DLG, [1/2 26/72], [3/40 1/18], [47/160 1/18], 'gx(x)   = ', '-e^(-(x-2)**2)', 'Composante en x de g(x,y) = gx(x)*gy(y)', false);
  [gtx3, ged3] = create_edit(DLG, [1/2 19/72], [3/40 1/18], [47/160 1/18], 'gy(y)   = ', 'e^(-(y-2)**2)', 'Composante en y de g(x,y) = gx(x)*gy(y)', false);
  gpb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Afficher g(x, y)', 'fontsize', 16, 'units', 'normalized', ...
          'position', [9/16 1/9 1/4 1/9], 'tooltipstring', 'Affiche g(x, y) en 3D');

  %start the simulation
  spb = uicontrol(DLG, 'style', 'pushbutton', 'string', 'Start', 'fontsize', 16, 'units', 'normalized', ...
          'position', [1/8 1/9 1/4 1/9], 'tooltipstring', 'Lance la simulation');
  %loading bar for ETA of simulation
  slb = create_loadbar(DLG, false, 0, [1/16 5/18 3/8 1/18], 2);
  svb = create_verbose(DLG, slb, [3/32 6/18 5/16 1/18], 20);

  %start values
  set(cb1, 'value', 0)
  set(cb2, 'value', 1)
  set(cb3, 'value', 1)
  set(cb4, 'value', 0)
  toggle_edit(ged1, ged2, ged3)

  %callbacks
  set(cb1, 'callback', @() toggle_edit(fed1, fed2, fed3))
  set(cb3, 'callback', @() toggle_edit(ged1, ged2, ged3))
  set(cb2, 'callback', @() toggle_visibilties(ftx1, ftx2, ftx3))
  set(cb4, 'callback', @() toggle_visibilties(gtx1, gtx2, gtx3))
  set(fpb, 'callback', {@plot_wave, cb1, cb2, fed1, fed2, fed3, sd3, sd4})
  set(gpb, 'callback', {@plot_wave, cb3, cb4, ged1, ged2, ged3, sd3, sd4})
  set(spb, 'callback', @() or_main(sd3, sd4, sd1, sd2, sd5, ...     %plot data
                                   cb1, cb2, fed1, fed2, fed3, ...  %f(x, y)
                                   cb3, cb4, ged1, ged2, ged3, ...  %g(x, y)
                                   slb, svb))                       %verbose

  clear tx* ftx* gtx* sd* fed* ged* *pb slb svb
  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end


function WIP(cbs='', evt=''),
  global DLG
  global CANCEL
  global DRAWING

  if DRAWING, return endif
  DRAWING = true;

  clf(DLG)
  str = ["WIP"; "This shouldn\47t be displayed."];

  set(DLG, 'color', [1 .8 .8])

  uicontrol(DLG, 'style', 'text', 'string', str, 'units', 'normalized', 'position', [.25 .5 .5 .2], ...
        'horizontalalignment', 'center', 'fontsize', 25, 'backgroundcolor', [1 .8 .8]);

  refresh(DLG)
  DRAWING = false;
  CANCEL = true;
end
