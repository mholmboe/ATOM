%% element_color.m 
% * This function assigns a certain color to each element. Estethic improvements are welcome...
%
%% Version
% 3.00
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% * color = element_atom('Li') 
%
function color = element_color(Atom_label)

color_vec={...
    'H'  [0.8 0.8 0.8] 1 'Hydrogen'; ...
    'Li' [.2 .2 1] 3 'Lithium'; ...
    'C'  [.2 .2 .2] 6 'Carbon'; ...
    'N'  [1 0.6 0] 7 'Nitrogen'; ...
    'O'  [1 0 0] 8 'Oxygen'; ...
    'Na' [0 0 1] 11 'Sodium'; ...
    'Mg' [0 .9 .9] 12 'Magnesium'; ...
    'Al' [0.7 0.5 0.5] 13 'Aluminum'; ...
    'Si' [.5 .5 0] 14 'Silicon'; ...
    'P'  [0.6 0.2 0.2] 15 'Phosphorus'; ...
    'S'  [1 1 0] 16 'Sulfur'; ...
    'Cl' [.4 1 .4] 17 'Chlorine'; ...
    'K'  [0 1 0] 19 'Potassium'; ...
    'Ca' [0.8 0.1 0.1] 20 'Calcium'; ...
    'Ti' [0.1 0.1 0.1] 22 'Titanium'; ...
    'V'  [0.7 0.4 0.4] 23 'Vanadium'; ...
    'Fe' [0 0 0.6] 26 'Iron'; ...
    'Ni' [1 0.2 0] 28 'Nickel'; ...
    'Cu' [0.7 0.4 0.2] 29 'Copper'; ...
    'Zn' [0.7 0.5 0.4] 30 'Zinc'; ...
    'Br' [0.9 0.4 0.2] 35 'Bromine'; ...
    'Rb' [1 0.4 0.2] 37 'Rubidium'; ...
    'Sr' [1 0.3 0.3] 38 'Strontium'; ...
    'I'  [1 0.6 0.2] 53 'Iodine'; ...
    'Cs' [0.8 0.9 0.9] 55 'Cesium'; ...
    'Ba' [1 0.2 0.2] 56 'Barium'; ...
    'W'  [0.8 0.2 0.2] 56 'Tungsten'; ...
    'Hw'  [0.8 0.8 0.8] 1 'Hydrogen'; ...
    'HW'  [0.8 0.8 0.8] 1 'Hydrogen'; ...
    'HW1' [0.8 0.8 0.8] 1 'Hydrogen'; ...
    'HW2' [0.8 0.8 0.8] 1 'Hydrogen'; ...
    'Ow'  [1 0 0] 8 'Oxygen';...
    'OW'  [1 0 0] 8 'Oxygen';...
    'D' [0 0 0] 10 'Dummy'};

ind=[];ind_array=[];
for i=1:length(Atom_label)
    Atom_label(i);
%     if numel(Atom_label(i))>1
        try
        ind=find(strncmpi(Atom_label(i),color_vec(:,1),2));
        catch
%     else
        ind=find(strncmpi(Atom_label(i),color_vec(:,1),1));
        end
%     end
    if numel(ind) == 0
        ind=find(strncmpi(Atom_label(i),color_vec(:,1),1));
        if numel(ind) == 0
            disp('Could not find color for')
            disp(Atom_label(i))
            disp('setting it to the dummy')
            ind = 10;
        end
    end
    ind_array=[ind_array ind(1)];
end
ind=ind_array;


color = cell2mat(color_vec(ind,2));

