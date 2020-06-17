classdef EuphonicSFTest < matlab.unittest.TestCase

    properties
        qpts
        pars
        scattering_lengths
        opts
        material_name
    end

    properties (ClassSetupParameter)
        temp = {300};
        materials = { ...
           {'quartz', {'model', 'CASTEP', ...
                       'model_args', {get_abspath('quartz.castep_bin', 'input')}}}, ...
          {'nacl', {'model', 'phonopy', ...
                    'model_kwargs' {'path', get_abspath('NaCl', 'input')}}}};
        dw_grid = {missing, [6,6,6]};
        bose = {missing, false};
        negative_e = {missing, true};
        conversion_mat =  {missing, (1/2)*[-1, 1, 1; 1, -1, 1; 1, 1, -1]};
        lim = {missing, 1e-9};
    end

    % These parameters are related to performance, and shouldn't change the
    % result
    properties (TestParameter)
        use_c = {false, true, true};
        n_threads = {int32(1), int32(1), int32(2)};
        chunk = {2, missing, missing};
    end

    methods (TestClassSetup)
        function setQpts(testCase, temp, materials, dw_grid, bose, ...
                         negative_e, conversion_mat, lim)
            qpts = [0.0, 0.0, 0.0;
                    0.1, 0.2, 0.3;
                    0.4, 0.5, 0.0;
                    0.6, 0.0, 0.7;
                    0.0, 0.8, 0.9];
            scattering_lengths = struct('La', 8.24, 'Zr', 7.16, 'O', 5.803, ...
                                        'Si', 4.1491, 'Na', 3.63, 'Cl', 9.577);
            scale = 1.0;

            opts = materials{2};
            % Only add values to opts if they aren't missing
            opts_keys = {'dw_grid', 'bose', 'negative_e', 'conversion_mat', ...
                         'lim'};
            opts_values = {dw_grid, bose, negative_e, conversion_mat, lim};
            for i=1:length(opts_keys)
                if ~ismissing(opts_values{i})
                    opts = [opts {opts_keys{i}, opts_values{i}}];
                end
            end

            testCase.qpts = qpts;
            testCase.pars = [temp scale];
            testCase.scattering_lengths = scattering_lengths;
            testCase.opts = opts;
            testCase.material_name = materials{1};
        end
    end

    methods(Test, ParameterCombination='sequential')
        function runTests(testCase, use_c, n_threads, chunk)
            run_tests = true;
            testCase.assumeEqual(run_tests, true);

            qpts = testCase.qpts;
            opts = testCase.opts;
            pars = testCase.pars;
            phonon_kwargs = {'phonon_kwargs', ...
                                {'asr', 'reciprocal', ...
                                 'use_c', use_c, ...
                                 'n_threads', n_threads}};
            opts = [opts phonon_kwargs];
            if ~ismissing(chunk)
                opts = [opts {'chunk', chunk}];
            end
            fname = get_expected_output_filename(testCase.material_name, ...
                                                 pars, opts);

            [w, sf] = euphonic_sf(qpts(:, 1), qpts(:, 2), qpts(:, 3), ...
                                  pars, testCase.scattering_lengths, opts);
            disp(fname);
        end
    end

    methods(Test)
        function generateTestData(testCase)
            generate_test_data = false;
            testCase.assumeEqual(generate_test_data, true);

            qpts = testCase.qpts;
            opts = testCase.opts;
            pars = testCase.pars;
            phonon_kwargs = {'phonon_kwargs', {'asr', 'reciprocal'}};
            opts = [opts phonon_kwargs];
            [w, sf] = euphonic_sf(qpts(:,1), qpts(:,2), qpts(:,3), ...
                                  testCase.pars, testCase.scattering_lengths, ...
                                  opts)
            fname = get_expected_output_filename(testCase.material_name, ...
                                                 pars, opts);
            save(get_abspath(fname, 'expected_output'), 'w', 'sf');
        end
    end
end