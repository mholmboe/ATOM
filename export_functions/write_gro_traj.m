%% write_gro_traj.m
% * This function writes a .gro trajectory
% * I think this function works...currently no support for printing velocities, see line 31
%
%% Version
% 2.11
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # write_gro_traj(atom,traj,Box_dim,filename_out) % Basic input arguments
%
function write_gro_traj(atom,traj,Box_dim,filename_out)

if regexp(filename_out,'.gro') ~= false
    filename_out = filename_out;
else
    filename_out = strcat(filename_out,'.gro');
end

Frames=size(traj,1);
nFrames=1:Frames;
nAtoms=size(atom,2);
Atom_section=cell(nAtoms,10);

fid = fopen(filename_out, 'W');
tic
for t=1:length(nFrames)
    t
    Title='.gro traj generated by matlab, t=';
    TitleTot={Title t};
    fprintf(fid,'%-40s%10.5f \n',TitleTot{:});
    fprintf(fid, '%-5i\n',nAtoms);
    
%     if isnan(atom(1).vx) || atom(1).vx == 0
        for i = 1:nAtoms
            Atom_section(i,1:7) = [atom(i).molid, atom(i).resname, atom(i).type, atom(i).index, traj(t,1+3*(i-1))/10, traj(t,2+3*(i-1))/10, traj(t,3+3*(i-1))/10];
            fprintf(fid, '%5d%-5s%5s%5d%8.3f%8.3f%8.3f\n', Atom_section{i,1:7});
         end
%     else
%         disp('Currently no support for printing velocities')
%         pause
%         for i = 1:nAtoms
%             atom(i).molid
%             atom(i).resname
%             atom(i).type
%             atom(i).index
%             traj(t,1+3*(i-1))/10
%             atom(i).vx(t)/10
%             Atom_section(1:10) = [atom(i).molid, atom(i).resname, atom(i).type, atom(i).index, traj(t,1+3*(i-1))/10, traj(t,2+3*(i-1))/10, traj(t,3+3*(i-1))/10, atom(i).vx(t)/10, atom(i).vy(t)/10, atom(i).vz(t)/10];
%             fprintf(fid, '%5d%-5s%5s%5d%8.3f%8.3f%8.3f%8.4f%8.4f%8.4f\n', Atom_section{1:10});
%         end
%     end
    
    if size(Box_dim,1)==1
        if size(Box_dim,2) == 3 || Box_dim(4) == 0 && Box_dim(5) == 0 && Box_dim(6) == 0
            fprintf(fid, '%10.5f%10.5f%10.5f\n',Box_dim(1:3)/10);
        else
            fprintf(fid, '%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f\n',Box_dim/10);
        end
    else
        if size(Box_dim(t,:),2) == 3
            fprintf(fid, '%10.5f%10.5f%10.5f\n',Box_dim(t,1:3)/10);
        elseif Box_dim(t,4) == 0 && Box_dim(t,5) == 0 && Box_dim(t,6) == 0
            fprintf(fid, '%10.5f%10.5f%10.5f\n',Box_dim(t,1:3)/10);
        else
            fprintf(fid, '%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f\n',Box_dim(t,:)/10);
        end
    end
    
    if mod(t,10)==0
        t
    end
    
end
toc
fclose(fid);

sprintf('.gro file exported %d frames', nFrames(end))

