clear

global PATHS  %relative path to simulations
global FLP    %fullpath of main directory (directory of this script)

pname = 'PDE visualisations - v1.0'
graphic = have_window_system();

FLP = mfilename('fullpath');
lnm = length(mfilename());
FLP = FLP(1:end-lnm);

PATHS = {
  [FLP 'onde/onde_rect.m'],                      %wave -> rect -> u(t=0) = f, du/dt(t=0) = g
  [FLP 'laplace/laplace_circ.m'],                %lapl -> circ -> u(r=a) = f
  [FLP 'laplace/laplace_rect_3hom.m']            %lapl -> rect -> u(x=L) = f
};

if !have_window_system(),
  disp('Terminal mode not implemented yet, work in progress.');
  return
end

source([FLP 'utils/callbacks.m'])
source([FLP 'utils/math_funs.m'])
source([FLP 'utils/utils.m'])
source([FLP 'utils/window_utils.m'])

global DLG
appli_gui(pname)
uiwait(DLG)
