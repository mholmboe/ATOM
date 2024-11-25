%% fit2lattice_atom.m
% * This is a special function imports a model structure of a single molecule
% * like PO43- and tries to fit it into a crystal lattice possibly holding
% * multiple such sites. Any waters or counter-ions (see lin 39) can be
% * reordered and reintroduced to the final model.
%
%
%% Version
% 3.00
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # [atom,Box_dim] = fit2lattice_atom(atom_model,atom_ref,Box_dim_ref) % Basic imput arguments
%

function [atom,Box_dim] = fit2lattice_atom(atom_model,atom_ref,Box_dim_ref,varargin)

% clear all;
% format compact;
%
% %% Set filenames/residue name
% ref_filename='H3PO4_CollCode15887.pdb'
% model_filename='1xH3PO4.pdb'
% %% Import and setup reference and model structures, strip away waters and counter-ions..
% model=import_atom(model_filename);
% ref=import_atom(ref_filename);

if nargin>3
    outfilename=varargin{1};
else
    outfilename='preem.gro';
end

if nargin > 4
    resname=varargin{2};
else
    resname='PO4';
end

model=atom_model;ref=atom_ref; % ref=preem;
ref=atom_ref;
Box_dim=Box_dim_ref;

ref=element_atom(ref);
[ref,SOL]=remove_H2O(ref,Box_dim); % Will output SOL
ref=resname_atom(ref,resname);

model=element_atom(model);
[model.molid]=deal(1);
[model.resname]=deal({resname});
model=bond_angle_atom(model,Box_dim,1.25,2.45,'more');

Ion=ref(strcmp([ref.resname],'ION'));
if numel(Ion)==0
    Ion=[];
end
ref(strcmp([ref.resname],'ION'))=[];
ref(strcmp([ref.resname],'SOL'))=[];
[ref.molid]=deal(1);
ref=update_atom(ref);
ref=bond_angle_atom(ref,Box_dim,1.25,2.45,'more');

%% Choose a main atomtype used for centering the model onto the reference structure
Atom_type=unique([ref.type]);
Atom_type(ismember(Atom_type,{'H' 'O' 'C' 'Li' 'Na' 'K' 'Ca' 'Mg' 'Cs'}))=[];

nAtomtypeRef=sum(strcmp([ref.type],Atom_type));
nAtomtypeModel=sum(strcmp([model.type],Atom_type));

AtomtypeRef_ind=find(strcmp([ref.type],Atom_type));
AtomtypeModel_ind=find(strcmp([model.type],Atom_type));

%% Calculate how many models would fit in reference
nRepFactor=nAtomtypeRef/nAtomtypeModel;

%% Place the model at origo
model=translate_atom(model,-[model(AtomtypeModel_ind(1)).x model(AtomtypeModel_ind(1)).y model(AtomtypeModel_ind(1)).z]);

%% For every model to be superpositioned over the reference...
full_model=[];BestAngles=[0 0 0]; BestAngles_all=[];res_all=[];
for i=1:nRepFactor
    close all
    n=1; prev_res=1E23;
    while sum(prev_res.^2)>0.1 && n < 5000

        %% Generate random angles between -180 to +180
        angles=[360*rand-180 360*rand-180 360*rand-180];

        %% Rotate and move the temporary model structure
        temp_model = rotate_atom(model,Box_dim,angles,AtomtypeModel_ind); % Rotate the temp_model around origo
        temp_model = translate_atom(temp_model,[ref(AtomtypeRef_ind(i)).x ref(AtomtypeRef_ind(i)).y ref(AtomtypeRef_ind(i)).z]); % Translate the temp_model to the i:th position

        H_res=0;d_ref_vec=0;d_model_vec=0;
        if sum(strcmp([model.type],'H'))>0

            d_H_matrix=dist_matrix_atom(temp_model(strcmp([temp_model.type],'H')),...
                ref(strcmp([ref.type],'H')),Box_dim);
            d_H_matrix=sort(d_H_matrix,2);
            d_H_vec=reshape(d_H_matrix,1,[]);

            H_res=d_H_vec(1:sum(strcmp([model.type],'H')));

            try
                fb_model = find_bonded_atom(model,Box_dim,'H','O');
            catch
                fb_model = find_bonded_atom(model,Box_dim,'H','Oh');
            end
            Oh_model_ind=type2_ind;
            [model(Oh_model_ind).type]=deal({'Oh'});

            try
                fb_ref = find_bonded_atom(ref,Box_dim,'H','O');

            catch
                fb_ref = find_bonded_atom(ref,Box_dim,'H','Oh');
            end
            Oh_ref_ind=type2_ind;
            [ref(Oh_ref_ind).type]=deal({'Oh'});

            %% Calculate and compare distance matrixes (reshaped to vectors in the end) for each temp_model structure and the respective part of the reference structure
            d_model_matrix=dist_matrix_atom(temp_model(Oh_model_ind),...
                ref(Oh_ref_ind),Box_dim);
            d_model_matrix=sort(d_model_matrix,2);
            d_model_vec=reshape(d_model_matrix,1,[]);
            d_model_vec=d_model_vec(1:sum(strcmp([model.type],'H')))

        else

            %% Calculate and compare distance matrixes (reshaped to vectors in the end) for each temp_model structure and the respective part of the reference structure
            d_model_matrix=dist_matrix_atom(temp_model(unique(temp_model((AtomtypeModel_ind(1))).angle.index(:,1:2:end))),...
                ref(unique(ref(AtomtypeRef_ind(i)).angle.index(:,1:2:end))),Box_dim);
            d_model_matrix=sort(d_model_matrix,2);
            d_model_vec=reshape(d_model_matrix,1,[]);

            d_ref_matrix=dist_matrix_atom(ref(unique(ref(AtomtypeRef_ind(i)).angle.index(:,1:2:end))),...
                ref(unique(ref(AtomtypeRef_ind(i)).angle.index(:,1:2:end))),Box_dim);
            d_ref_matrix=sort(d_ref_matrix,2);
            d_ref_vec=reshape(d_ref_matrix,1,[]);

        end

        %% Calculate the difference
        res=d_ref_vec-d_model_vec+sum(H_res)

        %% Save the best angles
        if sum(res.^2)<sum(prev_res.^2)
            best_model=temp_model; % New
            prev_res=res;
            BestAngles=[BestAngles;angles];
            hold on
            drawnow
            plot(res)
        end
        n=n+1;
    end
    if n>=10000
        disp('Did not really converge...')
        pause(2)
    end

    i
    sum(prev_res.^2)
    n

    sum(res.^2)
    res_all=[res_all sum(res.^2)];
    BestAngles_all = [BestAngles_all BestAngles(end,:)];

    %% Add the temp_model to the the full model
    full_model = update_atom({full_model best_model}); % New

end

%% Finalize and write the final structure, possibly with the original ions and waters (that have been reordered)
full_model = wrap_atom(full_model,Box_dim);
System=update_atom({full_model Ion SOL});
prop = analyze_atom(System,Box_dim,2.65);
write_atom_gro(System,Box_dim,strcat(char(outfilename),'_GII_',num2str(GII,3),'_',num2str(GII_noH,3),'.gro'));

atom = System;
% vmd(update_atom({ref full_model}),Box_dim)

