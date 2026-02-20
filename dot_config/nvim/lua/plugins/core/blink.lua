-- blink.cmp overrides
-- Uses Lua fuzzy implementation to avoid Rust compilation.
-- frizbee-0.7.0 (blink.cmp's dependency) is incompatible with recent Rust nightly
-- (std::simd::Select was removed). Remove this file once blink.cmp updates frizbee.
return {
  {
    "saghen/blink.cmp",
    build = false,
    opts = {
      fuzzy = {
        implementation = "prefer_rust",
      },
    },
  },
}
