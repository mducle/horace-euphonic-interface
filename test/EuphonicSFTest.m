classdef EuphonicSFTest < matlab.unittest.TestCase

    properties
        qpts
        pars
        scattering_lengths
        opts
    end

    properties (ClassSetupParameter)
        material_opts = {{'model', 'CASTEP', ...
                          'model_args', {get_abspath('quartz.castep_bin')}}, ...
                         {'model', 'CASTEP', ...
                          'model_args', {get_abspath('La2Zr2O7.castep_bin')}}, ...
                         {'model', 'phonopy', ...
                          'model_kwargs' {'path', get_abspath('NaCl')}}};
    end

    properties (TestParameter)
        use_c = {false, true, true};
        n_threads = {int32(1), int32(1), int32(2)};
    end

    methods (TestClassSetup)
        function setQpts(testCase, material_opts)
            qpts = [0.0, 0.0, 0.0;
                    0.1, 0.2, 0.3;
                    0.4, 0.5, 0.0;
                    0.6, 0.0, 0.7;
                    0.0, 0.8, 0.9];
            scattering_lengths = struct('La', 8.24, 'Zr', 7.16, 'O', 5.803, ...
                                        'Si', 4.1491, 'Na', 3.63, 'Cl', 9.577);
            scale = 1.0;
            temp = 5;

            testCase.qpts = qpts;
            testCase.pars = [temp scale];
            testCase.scattering_lengths = scattering_lengths;
            testCase.opts = material_opts;
        end
    end

    methods(Test, ParameterCombination='sequential')
        function testThing(testCase, use_c, n_threads)
            qpts = testCase.qpts;
            opts = testCase.opts;
            phonon_kwargs = {'phonon_kwargs', ...
                                {'asr', 'reciprocal', ...
                                 'use_c', use_c, ...
                                 'n_threads', n_threads}};
            opts = [opts phonon_kwargs];
            [w, sf] = euphonic_sf(qpts(:, 1), qpts(:, 2), qpts(:, 3), ...
                                  testCase.pars, ...
                                  testCase.scattering_lengths, opts);
        end
    end

    methods(Test)
        function generateTestData(testCase)
            generate_test_data = false;
            testCase.assumeEqual(generate_test_data, true);
            disp('Generating test data...')
        end
    end
end