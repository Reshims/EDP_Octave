clear;

global PATHS
PATHS = {
  "onde/onde_rect.m",                      %wave -> rect -> u(t=0) = f, du/dt(t=0) = g
  "laplace/laplace_circ.m",                %lapl -> circ -> u(r=a) = f
  "laplace/laplace_rect_3hom.m"            %lapl -> rect -> u(x=L) = f
};

pname = "PDE visualisations - v1.0"
graphic = have_window_system();

if !have_window_system(),
  disp('Terminal mode not implemented yet, work in progress.');
  return
end

source('utils/callbacks.m')
source('utils/math_funs.m')
source('utils/utils.m')
source("utils/window_utils.m")

global DLG
appli_gui(pname)
uiwait(DLG)
