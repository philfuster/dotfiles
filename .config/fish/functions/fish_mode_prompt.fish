function fish_mode_prompt
    # Intentionally empty: the vi-mode indicator is rendered inline
    # in fish_prompt so it participates in the themed bracket structure.
    # Without this override fish would print a separate [I]/[N] to the
    # left of the prompt, which Warp hides via its block UI but tmux
    # surfaces, producing a double indicator.
end
