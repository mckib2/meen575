classdef mrObj < handle
    properties
        % MR Properties
        gamma; % (rad/s/T) gyromagnetic ratio
        B0; % T
        offres; % off resonance, in Hz
        T1; % (ms) T1 decay constant
        T2; % (ms) T2 deca constant
        T2star; % (ms) T2* decay constant
        Rho; % size (x,y,z) describes density in the object
        
        % Point locations of the object (cm), consider origin (0,0,0)
        x; % 1D array
        y; % 1D array
        z; % 1D array
        
        % Signal
        spins; % For every point in the object, we have a spin
    end
    properties (Access = private)
        t_ms; % current time in milliseconds
        w0; % larmour freq
        
        Mz0; % Mz at excitation
        Mxy0; % Mxy at excitation
    end
    methods
        function [ obj ] = mrObj(varargin)
            % Try to assign all properties we get
            props = properties(obj);
            try
                for ii = 1:numel(props)
                    obj.(props{ii}) = cell2mat(varargin(ii));
                end
            catch
                % This is what happens when we run out of user supplied
                % arguments.
                
                % Give some default dimensions if we don't have any user
                % suppled ones:
                if isequal(obj.x,[])
                    obj.x = 1:10;
                end
                if isequal(obj.y,[])
                    obj.y = 1:10;
                end
                if isequal(obj.z,[])
                    obj.z = 1:10;
                end
                
                % Initialize spins to thermal equilibrium
                obj.spins = zeros(numel(obj.x),numel(obj.y),numel(obj.z),3);
                obj.spins(:,:,:,3) = ones(size(obj.spins(:,:,:,3)));
                
                % Let the current time be 0
                obj.t_ms = 0;
                
                % get the larmour freq
                obj.w0 = 2*pi*obj.gamma*obj.B0;
                
                % Current excitation 0 to fill Mz0 and Mxy0
                obj.excite(0);
            end
        end
        
        function [ t ] = getTime(obj)
            t = obj.t_ms;
        end
        
        function [ val ] = getFit(obj)
            % Filler value
            val = obj.T1;
        end
        
        function [ tval ] = getMxy(obj,x,y,z)
            tval = sqrt(obj.getMx(x,y,z)^2 + obj.getMy(x,y,z)^2);
        end
        function [ tval ] = getMx(obj,x,y,z)
            tval = squeeze(obj.spins(x,y,z,1));
        end
        function [ tval ] = getMy(obj,x,y,z)
            tval = squeeze(obj.spins(x,y,z,2));
        end
        function [ lval ] = getMz(obj,x,y,z)
            lval = squeeze(obj.spins(x,y,z,3));
        end
        
        function [ obj ] = excite(obj,theta,varargin)
            % When we get hit by RF, we tip by angle theta over the volume
            % described as x,y,z
            
            % Get the volume of excitation
            props = [ "x" "y" "z" ];
            vol = struct('x',[],'y',[],'z',[]);
            try
                for ii = 1:numel(props)
                    vol.(props(ii)) = cell2mat(varargin(ii));
                end
            catch
                % Set the whole volume as the default
                if ~isfield(vol,"x")
                    vol.x = obj.x;
                    vol.y = obj.y;
                    vol.z = obj.z;
                elseif ~isfield(vol,"y")
                    vol.y = obj.y;
                    vol.z = obj.z;
                elseif ~isfield(vol,"z")
                    vol.z = obj.z;
                end 
            end
            
            % Knock down the spins about the y axis
            for ii = vol.x
                for jj = vol.y
                    for kk = vol.z
                        v = squeeze(obj.spins(ii,jj,kk,:));
                        vprime = obj.rot(v,[ 0 theta 0 ]);
                        obj.spins(ii,jj,kk,:) = vprime;
                        
                        % Set excitation values
                        obj.Mz0(ii,jj,kk) = obj.getMz(ii,jj,kk);
                        obj.Mxy0(ii,jj,kk) = obj.getMxy(ii,jj,kk);
                    end
                end
            end
        end
        
        function [ obj ] = precess(obj,t_ms)
            % Free precession for the next t_ms
            obj.t_ms = obj.t_ms + t_ms;
            t = obj.t_ms;
            
            for ii = 1:numel(obj.x)
                for jj = 1:numel(obj.y)
                    for kk = 1:numel(obj.z)
                        % Longitudinal relaxation
                        M0 = obj.Rho(ii,jj,kk);
                        Mznew = M0 - (M0 - obj.Mz0(ii,jj,kk))*exp(-t/obj.T1);
                        
                        % Transverse relaxation
                        if obj.offres
                            c = 2*pi*obj.offres*t/1000;
                        else
                            c = 0;
                        end
                        Mxy00 = obj.Mxy0(ii,jj,kk)/sqrt(2);
                        Mxnew = Mxy00*exp(-t/obj.T2)*(cos(obj.w0*t + c) + sin(obj.w0*t + c));
                        Mynew = Mxy00*exp(-t/obj.T2)*(cos(obj.w0*t + c) - sin(obj.w0*t + c));
                        
                        % Update spins
                        obj.spins(ii,jj,kk,:) = [ Mxnew Mynew Mznew ].';
                    end
                end
            end
        end
        
    end
    methods(Static)
        function [ vprime ] = rot(v,ax)
            a = ax(1); b = ax(2); c = ax(3);
            Rx = [ 1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a) ];
            Ry = [ cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b) ];
            Rz = [ cos(c) -sin(c) 0; sin(c) cos(c) 0; 0 0 1 ];
            
            vprime = Rx*Ry*Rz*v;
        end
    end
end