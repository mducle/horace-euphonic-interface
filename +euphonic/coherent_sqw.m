classdef coherent_sqw < euphonic.light_python_wrapper
    % Matlab wrapper around a Euphonic interface Python class
    % To obtain help on this class and its methods please type help(class) or help(class.method) on the command line.
    % This will bring up the Python documentation
    properties(Access=protected)
        pyobj = [];  % Reference to python object
    end
    methods
        % Constructor
        function obj = coherent_sqw(varargin)
            eu = py.importlib.import_module('euphonic_wrapper');
            obj.helpref = eu.EuphonicWrapper;
            % Allow empty constructor for help function
            if ~isempty(varargin)
                args = euphonic.light_python_wrapper.parse_args(varargin, py.getattr(eu.EuphonicWrapper, '__init__'));
                obj.pyobj = py.euphonic_wrapper.EuphonicWrapper(args{:});
                obj.populate_props();
            end
        end
    end
end
