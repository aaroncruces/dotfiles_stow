hl.device({
    name = "sem-hct-keyboard",
    kb_layout = "es",
    -- Ensures no variant like latam; leave blank for standard Spanish (Spain)
    kb_variant = "",
})

hl.device({
    name = "zsa-technology-labs-ergodox-ez-keyboard",
    kb_layout = "us",
    kb_variant = "intl",
})

hl.device({
    name = "zsa-technology-labs-ergodox-ez",
    kb_layout = "us",
    kb_variant = "intl",
})

hl.device({
    name = "primax-kensington-eagle-trackball",
    sensitivity = 0.01,
    -- Option 1: No acceleration (constant speed regardless of movement)
    -- accel_profile = "flat",
    -- Option 2: Default adaptive
    accel_profile = "adaptive",
    -- Option 3: Custom acceleration curve (for fine-tuned increase/decrease)
    -- accel_profile = "custom 0.2 0.0 0.5 1.0 1.5",
    -- - Format: custom <step> <point1> <point2> ... (step is velocity increment; points are multipliers at each step).
    -- - Example above: Mild increase—slow movements (low velocity) have lower multipliers (less accel), faster ones ramp up.
    -- - To increase acceleration more aggressively: custom 0.1 0.0 0.3 0.8 1.5 2.0 (test and adjust points for your preference).
    -- - Leave points empty for a flat custom curve: custom # Equivalent to no acceleration.
})

hl.config({
    input = {
        -- kb_layout = "us",
        kb_layout = "es",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 0,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = false,
        },
    },
})