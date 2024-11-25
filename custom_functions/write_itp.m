function write_itp(itp,filename,varargin)
%% write_itp.m
%% This function prints a gromacs .itp file from a itp struct
%% Please report bugs to michael.holmboe@umu.se
%% Todo, varargin could be a distance_matrix whose values could be printed
%% to the bonds section...
%
%% Version
% 3.00
%
%% Contact
% Please report bugs to michael.holmboe@umu.se

format long

if nargin > 2
    scale_sigma=varargin{1};
else
    scale_sigma=1;
end

if nargin > 3
    scale_epsilon=varargin{2};
else
    scale_epsilon=1;
end

if nargin > 4
    scale_charge=varargin{3};
else
    scale_charge=1;
end

natoms=size(itp.atoms.nr,1);

if regexp(filename,'.itp') ~= false
    filename = filename;
else
    filename = strcat(filename,'.itp');
end

%% Create vars for the sections
names = fieldnames(itp);
for i=1:length(names)
    eval([names{i} '=itp.' names{i} ';']);
end

fid = fopen(filename, 'wt');

% fprintf(fid, '%s % s\r\n',';',filename);
fprintf(fid, '%s % s\r\n',';','Modifed itp file written by MHolmboe (michael.holmboe@umu.se)');
fprintf(fid, '\r\n');


if exist('atomtypes','var')
    fprintf(fid, '%s\r\n','[ atomtypes ]');
    fprintf(fid, '%s\r\n','; name   bond_type  mass     charge   ptype   sigma        epsilon   ;');
    for i = 1:size(itp.atomtypes.type,1)
        fprintf(fid, '%5s %5s       %8.5f  %8.5f %5s    %8.5e  %8.5e\r\n',char(itp.atomtypes.type(i)),char(itp.atomtypes.name(i)),itp.atomtypes.atnum(i),scale_charge*itp.atomtypes.charge(i),char(itp.atomtypes.ptype(i)),scale_sigma*itp.atomtypes.v(i),scale_epsilon*itp.atomtypes.w(i));
    end
end

fprintf(fid, '\r\n');

if exist('moleculetype','var')
    fprintf(fid, '%s\r\n','[ moleculetype ]');
    fprintf(fid, '%s % s\r\n',';','molname   nrexcl');
    fprintf(fid, '%s       %d\r\n',char(itp.moleculetype.moleculetype),str2double(itp.moleculetype.nrexcl));
    fprintf(fid, '\r\n');
end
fprintf(fid, '%s\r\n','[ atoms ]');
fprintf(fid, '%s\r\n',';    nr       type resnr residue  atom   cgnr     charge       mass     ; comment');

ChargeSumColumn=round(cumsum(itp.atoms.charge),5);
if exist('atoms','var')
    for i = 1:size(itp.atoms.nr,1)
        atoms_section(i,:) = {itp.atoms.nr(i), char(atoms.type(i)),itp.atoms.resnr(i),char(itp.atoms.residue(i)),char(itp.atoms.atom(i)),itp.atoms.nr(i), scale_charge*itp.atoms.charge(i),itp.atoms.mass(i), '; qtot ', scale_charge*ChargeSumColumn(i)};
        fprintf(fid, '%6i%11s%9i%5s%7s%7i\t%8.5f\t%8.4f\t%5s\t%8.5f\r\n',atoms_section{i,:});
    end
end

fprintf(fid, '\r\n');

if exist('bonds','var')
    fprintf(fid, '[ bonds ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj funct       c0        c1        c2         c3');
    if numel(itp.bonds)>0
        for i = 1:size(itp.bonds.ai,1)
            if numel(fieldnames(itp.bonds))<5
                if isfield(itp.bonds,'c0') && ~isnan(itp.bonds.c0(i)) && ~itp.bonds.c0(i)==0
                    Bond_order(i,:)= {itp.bonds.ai(i),itp.bonds.aj(i),itp.bonds.funct(i),itp.bonds.c0(i),';',char(itp.atoms.atom(itp.bonds.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.bonds.aj(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %10.5f %s %s %s\r\n', Bond_order{i,:});
                else
                    Bond_order(i,:)= {itp.bonds.ai(i),itp.bonds.aj(i),itp.bonds.funct(i),';',char(itp.atoms.atom(itp.bonds.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.bonds.aj(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %s %s %s\r\n', Bond_order{i,:});
                end
            elseif numel(fieldnames(itp.bonds))<6
                if isfield(itp.bonds,'c1') && ~isnan(itp.bonds.c0(i)) && ~itp.bonds.c0(i)==0
                    Bond_order(i,:)= {itp.bonds.ai(i),itp.bonds.aj(i),itp.bonds.funct(i),itp.bonds.c0(i),itp.bonds.c1(i),';',char(itp.atoms.atom(itp.bonds.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.bonds.aj(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %10.5f %10.2f %s %s %s\r\n', Bond_order{i,:});
                else
                    numel(fieldnames(itp.bonds))
                    fieldnames(itp.bonds)
                    disp('Did not write all bonded params, need to edit a new section for that...')
                end
            else
                numel(fieldnames(itp.bonds))
                fieldnames(itp.bonds)
                disp('Did not write all bonded params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('angles','var')
    fprintf(fid, '[ angles ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj    ak  funct      c0           c1         c2         c3');
    if numel(itp.angles)>0
        for i = 1:size(itp.angles.ai,1)
            if numel(fieldnames(itp.angles))<6
                if isfield(itp.angles,'c0') && ~isnan(itp.angles.c0(i)) && ~itp.angles.c0(i)==0
                    Angle_order(i,:)= {itp.angles.ai(i),itp.angles.aj(i),itp.angles.ak(i),itp.angles.funct(i),itp.angles.c0(i),';',char(itp.atoms.atom(itp.angles.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.ak(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %10.2f %s %s %s %s\r\n', Angle_order{i,:});
                else
                    Angle_order(i,:)= {itp.angles.ai(i),itp.angles.aj(i),itp.angles.ak(i),itp.angles.funct(i),';',char(itp.atoms.atom(itp.angles.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.ak(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %s %s %s %s\r\n', Angle_order{i,:});
                end
            elseif numel(fieldnames(itp.angles))<7
                if isfield(itp.angles,'c1') && ~isnan(itp.angles.c0(i)) && ~itp.angles.c0(i)==0
                    Angle_order(i,:)= {itp.angles.ai(i),itp.angles.aj(i),itp.angles.ak(i),itp.angles.funct(i),itp.angles.c0(i),itp.angles.c1(i),';',char(itp.atoms.atom(itp.angles.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.angles.ak(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %10.2f %10.2f %s %s %s %s\r\n', Angle_order{i,:});
                end
            else
                disp('Did not write all angle params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('pairs','var')
    fprintf(fid, '[ pairs ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj funct            c0            c1            c2            c3');
    if numel(itp.pairs)>0
        for i = 1:size(itp.pairs.ai,1)
            if numel(fieldnames(itp.pairs))<5
                if ~isnan(itp.pairs.c0(i))
                    Pair_order(i,:)= {itp.pairs.ai(i),itp.pairs.aj(i),itp.pairs.funct(i),itp.pairs.c0(i),';',char(itp.atoms.atom(itp.pairs.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.pairs.aj(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %12.2e %s %s %s\r\n', Pair_order{i,:});
                else
                    Pair_order(i,:)= {itp.pairs.ai(i),itp.pairs.aj(i),itp.pairs.funct(i),';',char(itp.atoms.atom(itp.pairs.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.pairs.aj(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %s %s %s\r\n', Pair_order{i,:});
                end
            elseif isnan(itp.pairs.c0(i))
                Pair_order(i,:)= {itp.pairs.ai(i),itp.pairs.aj(i),itp.pairs.funct(i),';',char(itp.atoms.atom(itp.pairs.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.pairs.aj(i)==itp.atoms.nr))};
                fprintf(fid, '%5i %5i %5i %s %s %s\r\n', Pair_order{i,:});
            else
                disp('Did not write all pair params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('exclusions','var')
    fprintf(fid, '[ exclusions ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj    ak  funct');
    if numel(itp.exclusions)>0
        for i = 1:size(itp.exclusions.ai,1)
            if numel(fieldnames(itp.exclusions))<5
                if ~isnan(itp.exclusions.c0(i))
                    Exclusion_order(i,:)= {itp.exclusions.ai(i),itp.exclusions.aj(i),itp.exclusions.ak(i),itp.exclusions.funct(i),itp.exclusions.c0(i)};
                    fprintf(fid, '%5i %5i %5i %5i %8.2f\r\n', Exclusion_order{i,:});
                else
                    Exclusion_order(i,:)= {itp.exclusions.ai(i),itp.exclusions.aj(i),itp.exclusions.ak(i),itp.exclusions.funct(i)};
                    fprintf(fid, '%5i %5i %5i %5i\r\n', Exclusion_order{i,:});
                end
            else
                disp('Did not write all exclusion params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('dihedrals','var')
    fprintf(fid, '[ dihedrals ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj    ak    al funct            c0            c1            c2            c3            c4            c5');
    if numel(itp.dihedrals)>0
        for i = 1:size(itp.dihedrals.ai,1)
            if numel(fieldnames(itp.dihedrals))<7
                if isfield(itp.dihedrals,'c0') && ~isnan(itp.dihedrals.c0(i))
                    Dihedral_order(i,:)= {itp.dihedrals.ai(i),itp.dihedrals.aj(i),itp.dihedrals.ak(i),itp.dihedrals.al(i),itp.dihedrals.funct(i),itp.dihedrals.c0(i),';',char(itp.atoms.atom(itp.dihedrals.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %8.2f %s %s %s %s %s\r\n', Dihedral_order{i,:});
                else
                    Dihedral_order(i,:)= {itp.dihedrals.ai(i),itp.dihedrals.aj(i),itp.dihedrals.ak(i),itp.dihedrals.al(i),itp.dihedrals.funct(i),';',char(itp.atoms.atom(itp.dihedrals.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %s %s %s %s %s\r\n', Dihedral_order{i,:});
                end
            elseif numel(fieldnames(itp.dihedrals))<8
                if isfield(itp.dihedrals,'c2') && ~isnan(itp.dihedrals.c2(i))
                    Dihedral_order(i,:)= {itp.dihedrals.ai(i),itp.dihedrals.aj(i),itp.dihedrals.ak(i),itp.dihedrals.al(i),itp.dihedrals.funct(i),itp.dihedrals.c0(i),itp.dihedrals.c1(i),';',char(itp.atoms.atom(itp.dihedrals.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %8.2f %8.4f %s %s %s %s %s\r\n', Dihedral_order{i,:});
                end
            elseif numel(fieldnames(itp.dihedrals))>8
                if isfield(itp.dihedrals,'c2') && ~isnan(itp.dihedrals.c2(i))
                    Dihedral_order(i,:)= {itp.dihedrals.ai(i),itp.dihedrals.aj(i),itp.dihedrals.ak(i),itp.dihedrals.al(i),itp.dihedrals.funct(i),itp.dihedrals.c0(i),itp.dihedrals.c1(i),itp.dihedrals.c2(i),';',char(itp.atoms.atom(itp.dihedrals.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.dihedrals.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %8.2f %8.4f %5i %s %s %s %s %s\r\n', Dihedral_order{i,:});
                end
            else
                disp('Did not write all dihedral params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('impropers','var')
    fprintf(fid, '[ impropers ] \r\n');
    fprintf(fid, '%s\r\n',';  ai    aj    ak    al funct            c0            c1            c2            c3            c4            c5');
    if numel(itp.impropers)>0
        for i = 1:size(itp.impropers.ai,1)
            if numel(fieldnames(itp.impropers))<7
                if isfield(itp.impropers,'c0') && ~isnan(itp.impropers.c0(i))
                    Improper_order(i,:)= {itp.impropers.ai(i),itp.impropers.aj(i),itp.impropers.ak(i),itp.impropers.al(i),itp.impropers.funct(i),itp.impropers.c0(i),';',char(itp.atoms.atom(itp.impropers.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %8.2f %s %s %s %s %s\r\n', Improper_order{i,:});
                else
                    Improper_order(i,:)= {itp.impropers.ai(i),itp.impropers.aj(i),itp.impropers.ak(i),itp.impropers.al(i),itp.impropers.funct(i),';',char(itp.atoms.atom(itp.impropers.ai(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.aj(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.ak(i)==itp.atoms.nr)),char(itp.atoms.atom(itp.impropers.al(i)==itp.atoms.nr))};
                    fprintf(fid, '%5i %5i %5i %5i %5i %s %s %s %s %s\r\n', Improper_order{i,:});
                end
            else
                disp('Did not write all improper params, need to edit a new section for that...')
            end
        end
    end
end

fprintf(fid, '\r\n');

if exist('enddata','var')
    end_string=cellstr(itp.enddata);
    fprintf(fid, '%s \r\n',end_string{:});
end

fprintf(fid, '\r\n');

fclose(fid);

