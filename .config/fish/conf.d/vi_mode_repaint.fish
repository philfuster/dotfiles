# Make fish_prompt redraw whenever the vi-binding mode changes, so the
# inline [I]/[N] indicator in fish_prompt stays in sync with fish_bind_mode.
function _nim_repaint_on_mode_change --on-variable fish_bind_mode
    commandline -f repaint
end
