%% Helper macro for declaring children of supervisor
-define(CHILD(I, Options, Type), {I, {I, start_link, Options}, permanent, 5000, Type, [I]}).
